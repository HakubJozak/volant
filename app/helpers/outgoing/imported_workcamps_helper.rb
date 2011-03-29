module Outgoing::ImportedWorkcampsHelper

  def state_column(wc)
    icon( wc.state, nil, true)
  end

end
