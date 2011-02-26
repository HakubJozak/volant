# Used to use 'render' methods outside the View/Controller layers
class TemplateRenderer < ActionController::Base

  attr_accessor :form

  public :render
end
