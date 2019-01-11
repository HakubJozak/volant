module StringWithVocative
  extend ActiveSupport::Concern

  def vocate(name_type)
    Vocative.find_vocative(name_type == 'firstname' ? 'f' : 's', self.gender, self[name_type])
  end

  def vocate_full
    (vocate(:firstname) + ' ' + vocate(:lastname)).strip
  end
end
