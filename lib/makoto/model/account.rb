require 'data_mapper'

module Makoto
  class Account
    include DataMapper::Resource

    property :acct, String, :unique_index => :uniqueness, :required => true
    property :favorability, Integer, :default  => 0
  end
end
