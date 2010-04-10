require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase

  def test_should_not_save_ad_without_link_and_description
    ad = Advertisement.new
    assert !ad.save
  end

  def test_should_not_save_ad_without_link
    ad = Advertisement.new
    ad.description = "test"
    assert !ad.save
  end

  def test_should_not_save_ad_without_description
    ad = Advertisement.new
    ad.link = "www.test.com"
    assert !ad.save
  end

end
