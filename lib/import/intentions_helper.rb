module Import
  module IntentionsHelper

    INTENTIONS_COMPATIBILITY_TABLE = {
      "CONC"=>"CONS",
      "REFU"=>"REFUGEE",
      "ENV"=>"ENVI",
      "DIS"=>"DISA",
      "DISABLED" => "DISA",
      "ART"=>"ARTS",
      "STUD"=>"STUDY",
      "REN"=>"RENO",
      "KID"=>"KIDS",
      "EDUC"=>"EDU",
      "MANUAL"=>"MANU",
      "YOUTH"=>"TEEN" }.freeze

    protected

    def import_intentions( text, wc)
      return unless text

      text.upcase.split(/\/|-|,/).each do |c|
        c = INTENTIONS_COMPATIBILITY_TABLE[c] || c
        intention = WorkcampIntention.find_by_code(c)

        if intention
          wc.intentions << intention
        else
          warning "WARNING: unknown work code '#{c}' in '#{wc.code}'"
        end
      end
    end

  end
end
