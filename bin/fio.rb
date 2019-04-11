#!/usr/bin/env ruby
# coding: utf-8


require 'http'
require 'json'
require 'pathname'
require 'nokogiri'
require 'active_support'
require 'active_support/core_ext'





class FioAPI
  def initialize
    path = Pathname.new(ENV['HOME']).join('Private/jakub.hozak/fio-token')
    @token = File.read(path).strip

  end

  def transactions
    get transactions_in_term_url(from: 3.days.ago, to: Date.today, format: :json)

  end


  private
    def get(url)
      
      @response = HTTP.use(logging: log_options).get(url)      

      require 'pry' ; binding.pry
      
      if @response.status.success?
        require 'pry' ; binding.pry
        File.open('a.json','w') { |f| f.write(r.body) }
      else
        puts @response.status
      end        
    end

    def last_transactions_url(format: :json)
      "https://www.fio.cz/ib_api/rest/last/#{$token}/transactions.#{format}"  
    end

    def log_options
      @log_options ||= {
        logger: Logger.new(STDOUT),
        level: 'INFO'
      }.freeze
    end


    def transactions_in_term_url(format: :json, from: Date.yesterday, to: Date.today)
      from = from.to_date.to_s
      to = to.to_date.to_s
      "https://www.fio.cz/ib_api/rest/periods/#{$token}/#{from}/#{to}/transactions.#{format}"
    end

    def log_url
      
    end
  
end


FioAPI.new.transactions


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


