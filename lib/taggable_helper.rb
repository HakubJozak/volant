# Helper methods for any AS controller above model
# with "acts_as_taggable" mark.
module TaggableHelper

  def self.render_tags(tags)
    tags.map { |tag| TaggableHelper::render_tag(tag) }.join(' ') if tags
  end

  def self.render_tag(tag)
    if tag
      style = "background-color:#{tag.color}; color:#{tag.text_color}"
      # link_to tag.name, tag_url(tag.id), :style => style
      "<span class=\"tag\" style=\"#{style}\">#{tag.name}</span>"
    end
  end

end
