class LanguagesController < ApplicationController
  active_scaffold :languages do |c|
    c.columns = [ :code, :triple_code, :name_en, :name_cs ]
  end
end
