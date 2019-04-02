#!/usr/bin/env ruby
# coding: utf-8


require 'http'
require 'json'
require 'pathname'
require 'nokogiri'



path = Pathname.new(ENV['HOME']).join('Private/jakub.hozak/fio-token')
$token = File.read(path).strip

def url(format)
  u = "https://www.fio.cz/ib_api/rest/periods/#{$token}/2019-04-01/2019-04-2/transactions.#{format}"
  puts u
  u
end

# r = HTTP.get(url(:xml))
# puts Nokogiri::XML.parse(r.body)


# r = HTTP.get(url(:json))
# h = JSON.parse(r.body)



r = HTTP.get(url(:json))
require 'pry' ; binding.pry
puts JSON.parse(r.body)


 # {"info"=>
 #    {"accountId"=>"2600560107",
 #     "bankId"=>"2010",
 #     "currency"=>"CZK",
 #     "iban"=>"CZ4820100000002600560107",
 #     "bic"=>"FIOBCZPPXXX",
 #     "openingBalance"=>71278.97,
 #     "closingBalance"=>51706.56,
 #     "dateStart"=>"2019-04-01+0200",
 #     "dateEnd"=>"2019-04-02+0200",
 #     "yearList"=>nil,
 #     "idList"=>nil,
 #     "idFrom"=>20792237215,
 #     "idTo"=>20795825004,
 #     "idLastDownload"=>nil},
 #   "transactionList"=>
 #    {"transaction"=>
 #      [{"column22"=>{"value"=>20792237215, "name"=>"ID pohybu", "id"=>22},
 #        "column0"=>{"value"=>"2019-04-01+0200", "name"=>"Datum", "id"=>0},
 #        "column1"=>{"value"=>-2000.0, "name"=>"Objem", "id"=>1},
 #        "column14"=>{"value"=>"CZK", "name"=>"Měna", "id"=>14},
 #        "column2"=>{"value"=>"2101005627", "name"=>"Protiúčet", "id"=>2},
 #        "column10"=>nil,
 #        "column3"=>{"value"=>"2010", "name"=>"Kód banky", "id"=>3},
 #        "column12"=>{"value"=>"Fio banka, a.s.", "name"=>"Název banky", "id"=>12},
 #        "column4"=>nil,
 #        "column5"=>nil,
 #        "column6"=>nil,
 #        "column7"=>nil,
 #        "column16"=>{"value"=>"sporeni", "name"=>"Zpráva pro příjemce", "id"=>16},
 #        "column8"=>{"value"=>"Platba převodem uvnitř banky", "name"=>"Typ", "id"=>8},
 #        "column9"=>nil,
 #        "column18"=>nil,
 #        "column25"=>{"value"=>"sporeni", "name"=>"Komentář", "id"=>25},
 #        "column26"=>nil,
 #        "column17"=>{"value"=>24204563081, "name"=>"ID pokynu", "id"=>17}}
