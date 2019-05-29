#!/usr/bin/env ruby
# coding: utf-8

require 'json'
require 'active_support'
require 'active_support/core_ext'

json = JSON.parse(File.read('a.json'))
json.deep_symbolize_keys!


info = json[:accountStatement][:info]
list = json[:accountStatement][:transactionList][:transaction]




