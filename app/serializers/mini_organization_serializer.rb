class MiniOrganizationSerializer < ApplicationSerializer
  attributes :id, :name, :code,
             :address,
             :contact_person,
             :phone,
             :mobile,
             :fax,
             :website
end
