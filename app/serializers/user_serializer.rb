class UserSerializer < Barbecue::BaseSerializer
  attributes :id, :email, :first_name, :last_name, :unsent_messages_count

  def unsent_messages_count
    object.messages.where(sent_at: nil).count
  end
end
