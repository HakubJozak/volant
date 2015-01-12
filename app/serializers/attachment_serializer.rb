class AttachmentSerializer < ApplicationSerializer
  attributes :id, :url, :filename, :type
  has_one :message, embed: :ids, include: false
  has_one :apply_form, embed: :ids, include: false
  has_one :workcamp, embed: :ids, include: false    

  def filename
    object.filename
  end

  def url
    object.file.try(:url)
  end

  def workcamp
    object.workcamp if object.respond_to?(:workcamp) 
  end

  def apply_form
    object.apply_form if object.respond_to?(:apply_form) 
  end    
end
