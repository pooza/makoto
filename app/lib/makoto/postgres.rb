require 'ginseng/postgres'

module Makoto
  class Postgres < Ginseng::Postgres::Database
    include Package

    def self.connect
      return instance
    end

    def self.dsn
      return Ginseng::Postgres::DSN.parse(Config.instance['/postgres/dsn'])
    end

    def self.health
      instance.connection.from(:account).first
      return {status: 'OK'}
    rescue
      return {status: 'NG'}
    end
  end
end
