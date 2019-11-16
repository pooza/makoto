require 'data_mapper'

module Makoto
  class Track
    include DataMapper::Resource

    property :id, Serial
    property :title, Text, :unique_index => :uniqueness, :required => true
    property :url, URI, :unique_index => :uniqueness, :required => true
    property :makoto, Boolean, :default  => false, :required => true
  end
end
