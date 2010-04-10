class ContactSourcesController < ApplicationController
  # GET /contact_sources
  # GET /contact_sources.xml
  
  before_filter :require_user

  def index
    @contact_sources = ContactSource.find_all_by_user_id current_user.id

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contact_sources }
    end
  end

  # GET /contact_sources/1
  # GET /contact_sources/1.xml
  def show
    @contact_source = ContactSource.find params[:id].to_i, :conditions => { :user_id => current_user.id }
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact_source }
    end
  end

  # GET /contact_sources/new
  # GET /contact_sources/new.xml
  def new
    @contact_source = ContactSource.new
    @contact_managers = AbstractContactManager.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact_source }
    end
  end

  # GET /contact_sources/1/edit
  def edit
    @contact_source = ContactSource.find(params[:id])
  end

  # POST /contact_sources
  # POST /contact_sources.xml
  def create
    @contact_source = ContactSource.new(params[:contact_source])
    @contact_source.user = current_user
    #@contact_source = ContactSource.new(params[:name] , params[:username] , params[:password], params[:note], current_user)

    respond_to do |format|
      if @contact_source.save
        flash[:notice] = 'ContactSource was successfully created.'
        format.html { redirect_to(@contact_source) }
        format.xml  { render :xml => @contact_source, :status => :created, :location => @contact_source }
      else
        flash[:notice] = 'adding a new contact source failed. please correct the errors and retry'
        @contact_managers = AbstractContactManager.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_sources/1
  # PUT /contact_sources/1.xml
  def update
    @contact_source = ContactSource.find params[:id].to_i, :conditions => { :user_id => current_user.id }

    respond_to do |format|
      if @contact_source.update_attributes(params[:contact_source])
        flash[:notice] = 'ContactSource was successfully updated.'
        format.html { redirect_to(@contact_source) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_sources/1
  # DELETE /contact_sources/1.xml
  def destroy
    @contact_source = ContactSource.find params[:id].to_i, :conditions => { :user_id => current_user.id }

    #delete any ContactsSyncedWithContactSource(wich reprecents relations between contacts and contact sources)
    #related to this ContactSource
    cswcs_to_be_deleted = ContactsSyncedWithContactSource.all :conditions => {:contact_source_id =>@contact_source.id}
    cswcs_to_be_deleted.each{|cswcs|
      cswcs.destroy
    }
    @contact_source.destroy

    respond_to do |format|
      format.html { redirect_to(contact_sources_url) }
      format.xml  { head :ok }
    end
  end

  def sync
    @contact_source = ContactSource.find(params[:id])

    if request.post? #its confirmed now import em
      begin
        sync_result = @contact_source.sync
        import_result = sync_result[:imported]
        export_result = sync_result[:exported]

        msg = <<END
        imported - #{import_result[:number_of_contacts_imported].to_s} |
        there was #{"no" if import_result[:importing_was_ok]} errors in the importing process |

        exported - #{export_result[:contacts_exported].to_s} |
        remotly deleted - #{sync_result[:deleted_remotly].length} |
        localy deleted - #{sync_result[:deleted_localy].length} |
END
        rescue Exception
        msg= "We are sorry a problem occured during the synchronizing process. please check your credentials"
      end
      if import_result[:importing_was_ok]
        flash[:notice] = msg
        redirect_to :controller=> "contacts", :action=> "index"
      else
        flash[:notice] = msg
        redirect_to :controller=> "contact_sources", :action=> "show", :id=>@contact_source.id
      end
      return

    else
      results = @contact_source.get_pre_sync_report
      @to_be_imported = results[:to_be_imported]
      @to_be_exported = results[:to_be_exported]
      @to_be_deleted_localy = results[:to_be_deleted_localy]
      @to_be_deleted_remotly = results[:to_be_deleted_remotly]
    end
  end
end
