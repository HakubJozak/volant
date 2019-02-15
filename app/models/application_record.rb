class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  # Adds scope which appends WHERE condition
  # only if the parameter is present.
  #
  # Usage:
  #
  # filter_scope :query, -> (str) {
  #   where("str ILIKE ?", "%#{str}%")
  # }
  #
  def self.filter_scope(name, hook)
    scope name, -> (param) do
      if param.present?
        hook.call(param)
      else
        where(nil)
      end
    end
  end
  
end
