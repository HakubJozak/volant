class ColoredTag < ActsAsTaggableOn::Tag

  COLOR_REGEXP = /#([0..9][A-F]){6}/

#  validates_format_of :color, :with => COLOR_REGEXP
#  validates_format_of :text_color, :with => COLOR_REGEXP

  # otherwise AS would use the helper method 'name_column' for other controllers
  def tag_name
    name
  end

  def self.find_by_model(model)
    Tag.find_by_sql([%{
         SELECT DISTINCT tags.*
         FROM tags INNER JOIN taggings
         ON taggings.tag_id = tags.id
         WHERE taggings.taggable_type = ?
         ORDER BY tags.name ASC
     }, model.to_s])
  end
end

# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  color          :string(7)        default("#FF0000"), not null
#  text_color     :string(7)        default("#FFFFFF"), not null
#  taggings_count :integer          default(0)
#  symbol         :string(255)
#
