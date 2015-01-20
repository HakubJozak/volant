module TaggableExtension
  def tag_ids=(ids)
    loaded = ColoredTag.find(ids)
    strings = loaded.map(&:name).join(',')
    self.tag_list = strings
    self.tags
  end
end
