# -*- coding: utf-8 -*-


attrs = { apply_form: {
                       motivation: 'I want to be a movie star',
                       general_remarks: 'vegetarian',
                       special_needs: 'eggnog',
                       gender: 'm',
                       firstname: 'TEST',
                       lastname: 'Tester',
                       birthnumber: '0103260424',
                       nationality: 'Austrian-Hungarian',
                       birthdate: '27-05-1901',
                       birthplace: 'Wien',
                       occupation: 'Ostrostřelec',
                       email: 'anton.spelec@gmail.com',
                       phone: '+420 777 123 456',
                       street: 'Unter den Linden 45',
                       city: 'Pest',
                       zipcode: '89056',
                       contact_street: '',
                       contact_city: '',
                       contact_zipcode: '',
                       emergency_day: '+420 777 999 999',
                       emergency_email: 'john@doe.com',
                       emergency_name: 'Yo Mama',
                       speak_well: 'Český a Maďarský',
                       speak_some: 'Dojč',
                       past_experience: 'I used to shoot things 100 years ago.',
                       workcamp_ids: [47059 ] # 46858
          }}

# host = 'volant.inexsda.cz'
# port = 443

require 'json'
require 'http'

r = HTTP.post("http://localhost:9090/v1/apply_forms", json: attrs) 
puts r.code
 # puts r.body



# puts 'Ltv'
# json = JSON.generate(attrs.merge(type: 'ltv'))
# response = Net::HTTP.new(host,port).post('/v1/apply_forms', json, { 'Content-Type' =>  'application/json' })
# puts response.body
# puts response.code
