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
    stripped = strip_cs_chars("#{@form.firstname}_#{@form.lastname}")
    "VEF_SDA_#{stripped.underscore}.#{sufix}"
  end
end
