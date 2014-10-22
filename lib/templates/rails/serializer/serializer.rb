<% module_namespacing do -%>
class <%= class_name %>Serializer < <%= parent_class_name %>
<% association_names.each do |attribute| -%>
  has_one :<%= attribute %>
<% end -%>

  def self.public_attributes
   []
  end

  def self.private_attributes
   [ <%= attributes_names.map(&:inspect).join(", ") %> ]
  end

  attributes *[ <%= class_name %>Serializer.public_attributes, <%= class_name %>Serializer.private_attributes ].flatten

end
<% end -%>
