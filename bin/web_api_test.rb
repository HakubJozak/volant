# -*- coding: utf-8 -*-

require 'json'
require 'net/http'

attrs = { apply_form: {
                       motivation: 'I want to be a movie star',
                       general_remarks: 'vegetarian',
                       gender: 'm',
                       firstname: 'Anton',
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
                       emergency_night: '+420 777 999 999',
                       emergency_name: 'Yo Mama',
                       speak_well: 'Český a Maďarský',
                       speak_some: 'Dojč',
                       past_experience: 'I used to shoot things 100 years ago.',
                       workcamp_ids: [47059 ] # 46858
  }}

# host = 'volant.pelican.amagical.net'
# port = 80

host = 'localhost'
port = 9090

puts 'Short'
json = JSON.generate(attrs)
response = Net::HTTP.new(host,port).post('/v1/apply_forms', json, { 'Content-Type' =>  'application/json' })
puts response.body
puts response.code

# puts 'Ltv'
# json = JSON.generate(attrs.merge(type: 'ltv'))
# response = Net::HTTP.new(host,port).post('/v1/apply_forms', json, { 'Content-Type' =>  'application/json' })
# puts response.body
# puts response.code
