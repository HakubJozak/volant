class V1::ShortWorkcampSerializer < ActiveModel::Serializer
  attributes :id,:name,:code,:begin,:end,:description,:workdesc
end
