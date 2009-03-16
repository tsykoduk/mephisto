class Admin::PluginsController < Admin::BaseController
  before_filter :find_plugin, :except => :index

  def index
    @plugins = Mephisto.plugins
  end
  
  def update
    @plugin.options = params[:options]
    @plugin.save!
    
    redirect_to :action => "show", :id => params[:id]
  end
  
  def destroy
    @plugin.destroy
    redirect_to :action => "show", :id => params[:id]
  end
  
  protected
  
    def find_plugin
      @plugin = Mephisto::Plugin[params[:id]]
    end
    
    alias authorized? global_admin?

end