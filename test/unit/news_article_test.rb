require 'test_helper'

class NewsArticleTest < ActiveSupport::TestCase
  def test_should_not_save_empty_article
    art = NewsArticle.new
    assert !art.save
  end

  def test_should_not_save_article_without_body
    art = NewsArticle.new
    art.title = "test title"
    assert !art.save
  end

  def test_should_not_save_article_without_title
    art = NewsArticle.new
    art.body = "test body"
    assert !art.save
  end
end
