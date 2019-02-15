module IconHelper

  def gender_sign(record)
    if record.gender == 'f'
      female_icon
    else
      male_icon
    end
  end

  def male_icon
    fa('mars')    
  end

  def female_icon
    fa('venus')    
  end    
end
