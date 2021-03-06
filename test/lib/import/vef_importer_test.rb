# -*- coding: utf-8 -*-
require 'test_helper'

module Import
  class VefImporterTest < ActiveSupport::TestCase

    setup do
      seed_countries
      @workcamp = create :incoming_workcamp
      @organization = create :organization, code: 'SJ'
    end

    test 'import' do
      i = VefImporter.new vef_file('vef_sda_josef_vysmejdil.xml')
      participant = i.import(@workcamp)

      assert_valid participant
      assert_valid apply_form = participant.apply_form
      assert_not_nil apply_form.id
      assert_not_nil participant.id

      wa = @workcamp.workcamp_assignments.first
      assert_not_nil wa
      assert_equal apply_form, wa.apply_form
      assert_equal :accepted, wa.state

      assert_equal @organization, participant.organization
      assert_equal @workcamp, participant.workcamp

      assert_equal 'Vyšmejdil', apply_form.lastname
      assert_equal Date.new(1977, 1, 12), apply_form.birthdate
      assert_equal 'Prague', apply_form.birthplace
      assert_equal '123Pas', apply_form.passport_number

      assert_equal 'Praha 9', apply_form.city
      assert_equal 'Makedonská 88, Praha 9', apply_form.street

      assert_equal 'Londýnská 33, Praha 9', apply_form.contact_street
      assert_equal '19000', apply_form.zipcode
      assert_equal 'EMP', apply_form.occupation
      assert_equal 'czech', apply_form.nationality
      assert_equal 'I am really motivated.', apply_form.motivation
      assert_equal 'I did some stuff.', apply_form.past_experience
      assert_equal 'czech english', apply_form.speak_well
      assert_equal 'german french, Chinese', apply_form.speak_some
      assert_equal 'Ginger Mašová,+420 234567890', apply_form.emergency_name
      assert_equal 'I can fly', apply_form.general_remarks
      assert_equal 'no fish', apply_form.special_needs
    end

    # test 'real 2016 vef' do
    #   i = VefImporter.new vef_file 'VEF_SJ_test.xml'
    #   assert_not_nil apply_form = i.import
    # end

    private

    def vef_file(name)
      File.new("test/fixtures/vef/#{name}")
    end

  end
end
