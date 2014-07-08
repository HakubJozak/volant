class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :code,
             :address,
             :contact_person,
             :phone,
             :mobile,
             :fax,
             :website
end
