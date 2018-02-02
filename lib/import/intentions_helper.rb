module Import
  module IntentionsHelper

    INTENTIONS_COMPATIBILITY_TABLE = {
      "CONC"=>"CONS",
      "ENV"=>"ENVI",

      "REFU"    => "SOCI",
      "REFUGEE" => "SOCI",
      "DIS"     => "SOCI",
      "DISA"    => "SOCI",
      "DISABLED"=> "SOCI",

      "ART"=>"ARTS",
      "STUD"=>"STUDY",
      "REN"=>"RENO",
      "KID"=>"KIDS",
      "EDUC"=>"EDU",
      "MANUAL"=>"MANU",
      "YOUTH"=>"TEEN"
    }.freeze
    
    protected

    def import_intentions(text, wc)
      return unless text

      codes = text.upcase.split(/\/|-|,/).map! do |c|
        INTENTIONS_COMPATIBILITY_TABLE.fetch(c,c)
      end

      codes.uniq.each do |code|
        if intention = WorkcampIntention.find_by_code(code)
          wc.intentions << intention
        else
          warning "WARNING: unknown work code '#{code}' in '#{wc.code}'"
        end
      end
    end

  end
end
