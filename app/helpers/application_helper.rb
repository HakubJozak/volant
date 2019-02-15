module ApplicationHelper
  def gender_sign(record)
    if record.gender == 'f'
      fa('venus')
    else
      fa('mars')
    end
  end

end
