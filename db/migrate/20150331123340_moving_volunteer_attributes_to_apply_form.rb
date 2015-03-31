class MovingVolunteerAttributesToApplyForm < ActiveRecord::Migration
  STRINGS = [ :firstname, :lastname, :gender,  
        :email,:phone,:birthnumber,:occupation,:account,
        :emergency_name,:emergency_day,:emergency_night,
        :speak_well,:speak_some,:fax,:street,
        :city,:zipcode,:contact_street,
        :contact_city,:contact_zipcode,
        :birthplace,:nationality ]

  TEXTS = [ :special_needs, :past_experience, :comments, :note ]


  def change
    add_strings *STRINGS
    add_texts  *TEXTS
    add_column :apply_forms, :birthdate, :date

    ApplyForm.reset_column_information

    ApplyForm.year(2015).find_each do |form|
      puts "#{form.name}(#{form.id})"
      
      (TEXTS + STRINGS + [:birthdate]).flatten.each do |attr|
        form.send "#{attr}=", form.volunteer.send(attr)
      end
      
      form.save(validate: false)
    end
  end

  private
  
  def add_strings(*names)
    names.each do |attr|
      add attr,:string
    end
  end

  def add_texts(*names)
    names.each do |attr|
      add attr,:text
    end
  end  

  def add(attr,type)
    add_column :apply_forms, attr, type
  end
end
