class Public::CountryCart

  def initialize
    @countries = Set.new
  end

 def add_country(country)
   if country.respond_to? :code
    @countries.add(country.code)
   else
    @countries.add(country)
   end
  end

  def remove_country(code)
    @countries -= [ code ]
  end

  def clear_countries
    @countries.clear
  end

  def countries
    @countries.to_a.sort.map do |code|
      Country.find_by_code(code)
    end
  end

  def country_codes
    @countries.to_a
  end

end
