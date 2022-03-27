module Makoto
  class GoodMorningMonologueWorkerTest < TestCase
    def setup
      @worker = GoodMorningMonologueWorker.new
    end

    def test_holiday_messages
      Timecop.travel(Time.parse('2000/5/17'))
      assert_empty(@worker.holiday_messages)
      Timecop.travel(Time.parse('2000/1/1'))
      assert_predicate(@worker.holiday_messages, :present?)
    end

    def test_greeting
      assert_predicate(@worker.greeting, :present?)
    end

    def test_perform
      return if Environment.ci?
      Timecop.travel(Time.parse('2020/01/01'))
      @worker.perform
      Timecop.travel(Time.parse('2020/02/01'))
      @worker.perform
      Timecop.travel(Time.parse('2020/02/02'))
      @worker.perform
      Timecop.travel(Time.parse('2020/12/24'))
      @worker.perform
    end
  end
end
