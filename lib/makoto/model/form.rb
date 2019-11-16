require 'data_mapper'

module Makoto
  class Form
    include DataMapper::Resource

    property :id, Serial
    property :name, String, :unique_index => :uniqueness, :required => true
  end
end
