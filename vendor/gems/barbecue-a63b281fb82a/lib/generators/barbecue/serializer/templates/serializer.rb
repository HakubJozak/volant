<% module_namespacing do -%>
class <%= class_name %>Serializer < <%= parent_class_name %>
<% association_names.each do |attribute| -%>
  has_one :<%= attribute %>
<% end -%>
  readonly_attributes :id
  writable_attributes
end
<% end -%>
