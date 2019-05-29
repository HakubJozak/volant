#!/usr/bin/env ruby
# coding: utf-8

require 'nokogiri'
require 'active_support'
require 'active_support/core_ext'

xml = Nokogiri::XML(File.read('a.xml'))


xml.xpath('/AccountStatement/TransactionList/Transaction').each do |t|
  require 'pry' ; binding.pry
  puts t
end


class FioTransaction
  def initialize(node)
    @node = node
  end

  -> (num, node) {
    el = node.xpath("/column_#{number}")
    OpenStruct.new(name: el.attrs['name'], value: el.text)
  }


end
