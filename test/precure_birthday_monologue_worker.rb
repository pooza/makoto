module Makoto
  class PrecureBirthdayMonologueWorkerTest < TestCase
    def setup
      @worker = PrecureBirthdayMonologueWorker.new
    end

    def test_perform
      Timecop.travel(Time.parse('2020/03/09'))
      @worker.perform
      Timecop.travel(Time.parse('2020/09/08'))
      @worker.perform
      Timecop.travel(Time.parse('2020/09/09'))
      @worker.perform
    end

    def test_girls
      assert_kind_of(Array, @worker.girls)
    end
  end
end
