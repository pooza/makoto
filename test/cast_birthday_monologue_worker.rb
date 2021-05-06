require 'timecop'

module Makoto
  class CastBirthdayMonologueWorkerTest < TestCase
    def setup
      @worker = CastBirthdayMonologueWorker.new
    end

    def test_perform
      Timecop.travel(Time.parse('2020/05/28'))
      @worker.perform
      Timecop.travel(Time.parse('2020/05/29'))
      @worker.perform
      Timecop.travel(Time.parse('2020/05/30'))
      @worker.perform
    end

    def test_casts
      assert_kind_of(Array, @worker.casts)
    end
  end
end
