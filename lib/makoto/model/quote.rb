require 'data_mapper'

module Makoto
  class Quote
    include DataMapper::Resource

    property :id, Serial
    property :episode, Integer
    property :emotion, String
    property :exclude, Boolean, :default  => false, :required => true
    property :exclude_respond, Boolean, :default  => false, :required => true
    property :priority, Integer, :default  => 3, :required => true
    property :body, String, :required => true
    property :remark, String

    belongs_to :series
    belongs_to :form
  end
end
