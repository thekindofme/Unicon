class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.xml

  before_filter :require_user

  def index
    #use the all_contacts method to make sure you do not get
    #deleted contacts(ie:- deleted = true)
    @contacts = Contact.all_contacts current_user.id

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find params[:id], :conditions => { :user_id => current_user.id }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact_sources = ContactSource.find_all_by_user_id current_user.id
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact_sources = ContactSource.find_all_by_user_id current_user.id
    @contact = Contact.find params[:id], :conditions => { :user_id => current_user.id }
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact_sources = ContactSource.find_all_by_user_id current_user.id
    contact_from = params[:contact]
    contact_from[:contact_source] = ContactSource.find params[:contact][:contact_source], :conditions => { :user_id => current_user.id }
    @contact = Contact.new(contact_from)
    @contact.user = current_user
    #@contact.contact_source = ContactSource.find_by_id(params[:contact].contact_source)

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(@contact) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    #we are receiving the selected contact source's id in the param's hence we
    #have to convert it to a real object
    contact_from = params[:contact]
    contact_from[:contact_source] = ContactSource.find params[:contact][:contact_source], :conditions => { :user_id => current_user.id }

    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(contact_from)
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find params[:id], :conditions => { :user_id => current_user.id }
    @contact.sync_safe_delete

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
