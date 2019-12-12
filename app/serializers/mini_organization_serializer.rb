class MiniOrganizationSerializer < ApplicationSerializer
  attributes :id, :name, :code,
             :address,
             :contact_person,
             :phone,
             :mobile,
             :fax,
   :website,
    :outgoing_email,  :incoming_email,  :ltv_email
  has_one :country, embed: :ids, include: true



end
