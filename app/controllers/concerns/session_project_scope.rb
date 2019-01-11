module SessionProjectScope
  extend ActiveSupport::Concern

  included do
    helper_method :change_mode_path
    helper_method :change_year_path
  end

  private
    def change_mode_path(mode)
      
    end

    def change_year_path(year)
    end

    
    # # Usage:
    # #
    # #   project_mode = :incoming
    # # 
    # def default_mode=(value)
    #   session[:mode] = value
    # end

    # def default_year=(value)
    #   session[:year] = value
    # end    
  
end
