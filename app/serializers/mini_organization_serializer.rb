class MiniOrganizationSerializer < ApplicationSerializer
  attributes :id, :name, :code,
             :address,
             :contact_person,
             :phone,
             :mobile,
             :fax,
             :website
  has_one :country, embed: :ids, include: true  
end
