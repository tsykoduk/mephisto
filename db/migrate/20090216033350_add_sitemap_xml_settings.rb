class AddSitemapXmlSettings < ActiveRecord::Migration
  def self.up
    add_column :sites, :sitemap_section_changefreq, :string
    add_column :sites, :sitemap_section_priority, :float
    add_column :sites, :sitemap_article_priority, :float
    add_column :sites, :sitemap_article_changefreq, :string
    add_column :sites, :sitemap_home_changefreq, :string
    add_column :sites, :sitemap_home_article_priority, :float
  end

  def self.down
    remove_column :sites, :sitemap_home_article_priority
    remove_column :sites, :sitemap_home_changefreq
    remove_column :sites, :sitemap_article_changefreq
    remove_column :sites, :sitemap_article_priority
    remove_column :sites, :sitemap_section_priority
    remove_column :sites, :sitemap_section_changefreq
  end
end
