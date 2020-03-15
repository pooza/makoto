module Makoto
  class GoodMorningMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = GoodMorningMonologueWorker.new
    end

    def holiday_messages
      Timecop.travel(Time.parse('2000/5/17'))
      assert_equal(@worker.holiday_messages, [])
      Timecop.travel(Time.parse('2000/1/1'))
      assert(@worker.holiday_messages.present?)
    end

    def test_greeting
      assert(@worker.greeting.present?)
    end

    def test_perform
      Timecop.travel(Time.parse('2020/01/01'))
      @worker.perform
      Timecop.travel(Time.parse('2020/02/01'))
      @worker.perform
      Timecop.travel(Time.parse('2020/02/02'))
      @worker.perform
    end
  end
end
