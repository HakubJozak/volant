module TaggableExtension
  extend ActiveSupport::Concern

  included do
    scope :with_tags, lambda { |*ids|
      query = where('true')

      ids.each_with_index do |id,i|
        name = "taggings_#{i}"
        sql = %(INNER JOIN "taggings" as #{name} ON "#{name}"."taggable_id" = "#{table_name}"."id" AND "#{name}"."taggable_type" = '#{self.name}')
        query = query.joins(sql).where("#{name}.tag_id = ?",id)
      end

      query
    }
  end

  def tag_ids=(ids)
    loaded = ColoredTag.find(ids)
    strings = loaded.map(&:name).join(',')
    self.tag_list = strings
    self.tags
  end
end
