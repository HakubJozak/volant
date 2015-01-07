class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :filename
  has_one :message, embed: :ids, include: false

  def filename
    object.file.try(:filename) || '[no-name]'
  end

  def url
    object.file.try(:url)
  end
end
