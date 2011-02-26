class Partnership < ActiveRecord::Base
  enforce_schema_rules

  belongs_to :organization
  belongs_to :network

  def to_label
    network.name
  end
end
