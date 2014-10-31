class UserSerializer < ActiveModel::Serializer
  has_many :messages, embed: :ids, include: false
  attributes :id, :email, :first_name, :last_name
end
