# coding: utf-8
require 'test_helper'

class VocativeTest < ActiveSupport::TestCase
  setup do
    seed_names
  end

  test 'user#vocative' do
    app = create(:apply_form, firstname: 'jAn', lastname: 'Novák')
    assert_equal 'Jane', app.firstname.vocative.to_s
    assert_equal 'Nováku', app.lastname.vocative.to_s
  end

  test 'user#vocative - unknown' do
    app = create(:apply_form, firstname: 'James', lastname: 'Xxx')
    assert_equal 'James', app.firstname.vocative.to_s
    assert_equal 'Xxx', app.lastname.vocative.to_s
  end  

  private
    def seed_names
      [ [ "Jiří","Jiří" ],
        [ "Jan","Jane" ],
        [ "Petr","Petře" ] ].each do |n,v|
	Vocative.create(nominative: n.downcase,
                        vocative: v,
                        name_type: 'f',
                        gender: 'm')
      end

      [ ["Novák","Nováku"],
        ["Svoboda","Svobodo"],
        ["Novotný","Novotný"] ].each do |n,v|
	Vocative.create(nominative: n.downcase,
                        vocative: v, name_type: 's',
                        gender: 'm')        
      end
    end

end
