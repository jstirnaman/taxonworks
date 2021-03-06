module DataControllerConfiguration
  extend ActiveSupport::Concern

  included do
    before_filter :set_is_data_controller, :set_data_model
  end

  protected

  def set_is_data_controller 
    @is_data_controller = true
  end 

  def set_data_model
    @data_model = controller_name.classify.constantize
  end 

end
