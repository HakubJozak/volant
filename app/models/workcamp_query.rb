class WorkcampQuery
  include ActiveModel::Model

  attr_accessor :order, :asc, :query

  def to_s
    query || ""
  end
end
