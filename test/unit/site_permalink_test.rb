require File.dirname(__FILE__) + '/../test_helper'
require 'site'

class SitePermalinkValidationsTest < ActiveSupport::TestCase
  fixtures :sites
  
  def setup
    @site = sites(:first)
  end
  
  test "should strip ending and beginning slashes" do
    @site.permalink_style = '/:year/:month/:day/:permalink/'
    assert @site.valid?
    assert_equal ':year/:month/:day/:permalink', @site.permalink_style
  end
  
  test "should not allow empty paths" do
    @site.permalink_style = ':year//:month/:day/:permalink'
    assert !@site.valid?
    assert_match /blank/, @site.errors.on(:permalink_style)
  end
  
  test "should require either permalink or id" do
    @site.permalink_style = ':year/:month/:day'
    assert !@site.valid?
    assert_equal "must contain either :permalink or :id", @site.errors.on(:permalink_style)
  end
  
  test "should require at least year for any date based permalinks" do
    %w(month day).each do |var|
      @site.permalink_style = ":#{var}/:id"
      assert !@site.valid?
      assert_equal "must contain :year for any date-based permalinks", @site.errors.on(:permalink_style)
    end
  end
  
  test "should require valid attributes" do
    @site.permalink_style = ':year/:month/:day/:permalink/:id'
    assert @site.valid?

    @site.permalink_style = ':year/:foo/:month/:day/:permalink'
    assert !@site.valid?
    assert_equal "cannot contain ':foo' variable", @site.errors.on(:permalink_style)
  end

  test "should not recongize hyphens as token separators" do
    @site.permalink_style = ':id-:permalink'
    assert !@site.valid?
  end
end

class SitePermalinkGenerationTest < ActiveSupport::TestCase
  fixtures :sites, :contents
  
  def setup
    @site    = sites(:first)
    @article = contents(:welcome)
  end

  test "should generate correct permalink format" do
    assert_equal "/#{@article.year}/#{@article.month}/#{@article.day}/#{@article.permalink}", @site.permalink_for(@article)
  end

  test "should generate correct permalink format with comment" do
    assert_equal "/#{@article.year}/#{@article.month}/#{@article.day}/#{@article.permalink}", @site.permalink_for(contents(:welcome_comment))
  end

  test "should generate correct permalink format for draft" do
    @article.published_at = nil
    now = Time.now.utc
    assert_equal "/#{now.year}/#{now.month}/#{now.day}/#{@article.permalink}", @site.permalink_for(@article)
  end

  test "should generate custom id permalink" do
    @site.permalink_style = 'posts/:year/:id'
    assert @site.valid?
    assert_equal "/posts/#{@article.year}/#{@article.id}", @site.permalink_for(@article)
  end

  test "should generate custom id permalink with comment" do
    @site.permalink_style = 'posts/:year/:id'
    assert @site.valid?
    assert_equal "/posts/#{@article.year}/#{@article.id}", @site.permalink_for(contents(:welcome_comment))
  end
end
