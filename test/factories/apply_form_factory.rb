# do not use! it has no assignment
Factory.define :apply_form, :class => Outgoing::ApplyForm do |f|
  f.association :volunteer
  f.association :payment
  f.fee 2200
  f.general_remarks "nothing to say"
  f.motivation "i don't want to go there"
end

Factory.define :paid_form, :parent => :apply_form do |f|
  f.after_create do |form|
     Factory.create(:workcamp_assignment, :apply_form => form)
     form.reload
  end
end


Factory.define :form_male, :parent => :apply_form do |f|
  f.association :volunteer, :factory => :male
end


Factory.define :form_female, :parent => :paid_form do |f|
  f.association :volunteer, :factory => :female
end


Factory.define :accepted_form, :parent => :apply_form do |f|
  f.after_create do |form|
    Factory.create(:workcamp_assignment, :apply_form => form, :accepted => Time.now )
    form.reload
  end
end

Factory.define :rejected_form, :parent => :apply_form do |f|
  f.after_create do |form|
    Factory.create(:workcamp_assignment, :apply_form => form, :rejected => Time.now )
    form.reload
  end
end
