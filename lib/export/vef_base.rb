class Export::VefBase

  include CzechUtils
  attr_reader :form

  def initialize(apply_form)
    @form = apply_form
  end

  def sufix
    raise NotImplementedError.new 'please, override this method'
  end

  def filename
    if v = @form.try(:volunteer)
      stripped = strip_cs_chars("#{v.firstname}_#{v.lastname}")
      "VEF_SDA_#{stripped.underscore}.#{sufix}"
    else
      "vef.#{sufix}"
    end
  end
end
