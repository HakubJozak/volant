# -*- coding: utf-8 -*-

require 'json'
require 'net/http'

json = JSON.generate(apply_form: {
                       motivation: 'I want to be a movie star',
                       general_remarks: 'vegetarian',
                       gender: 'm',
                       firstname: 'Anton',
                       lastname: 'Špelec',
                       birthnumber: '0103260424',
                       nationality: 'Austrian-Hungarian',
                       birthdate: '27-05-1901',
                       birthplace: 'Wien',
                       occupation: 'Ostrostřelec',
                       email: 'anton.spelec@gmail.com',
                       phone: '+420 777 123 456',
                       fax: "I do not own such device",

                       street: 'Unter den Linden 45',
                       city: 'Pest',
                       zipcode: '89056'
                       
                       contact_street:
                       contact_zipcode:
                       
                       emergency_day: '+420 777 999 999',
                       emergency_night: '+420 777 999 999',
                       emergency_name: 'Yo Mama',
                       speak_well: 'Český a Maďarský',
                       speak_some: 'Dojč',
                       past_experience: 'I used to shoot things 100 years ago.',
                       workcamp_ids: [ 45588, 46406 ]
                     })

# host = 'volant.pelican.amagical.net'
host = 'localhost'

response = Net::HTTP.new(host,9090).post('/v1/apply_forms', json, { 'Content-Type' =>  'application/json' })


puts response.body
puts response.code
