# class ActiveRecord::Base
#   def self.auto_complete_finder_for(field)
#     eval %{
#       def self.find_records_like(text)
#         search = '%' + text.downcase + '%'
#         self.find(:all,
#                   :conditions => ['lower(volunteers.lastname) LIKE ?', search],
#                   :include => :volunteer,
#                   :order => 'volunteers.lastname ASC',
#                   :limit => 15)
#       end
#     }
#   end
# end
