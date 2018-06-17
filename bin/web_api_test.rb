# -*- coding: utf-8 -*-

require 'json'
# require 'net/http'
require 'net/https'

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
                       emergency_email: '+420 777 999 999',
                       emergency_name: 'Yo Mama',
                       speak_well: 'Český a Maďarský',
                       speak_some: 'Dojč',
                       past_experience: 'I used to shoot things 100 years ago.',
                       workcamp_ids: [47059 ] # 46858
          }}

host = 'volant.inexsda.cz'
port = 443

# host = 'localhost'
# port = 9090

puts 'Short'
json = JSON.generate(attrs)

Net::HTTP.start(host,port, use_ssl: true) do |http|
  request = Net::HTTP::Post.new('/v1/apply_forms')
  request.set_form_data(json)
  request['Content-Type'] =  'application/json'
  response = http.request request
  puts response.code
end



# puts 'Ltv'
# json = JSON.generate(attrs.merge(type: 'ltv'))
# response = Net::HTTP.new(host,port).post('/v1/apply_forms', json, { 'Content-Type' =>  'application/json' })
# puts response.body
# puts response.code
