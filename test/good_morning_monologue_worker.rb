module Makoto
  class GoodMorningMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = GoodMorningMonologueWorker.new
    end

    def test_holiday_greeting
      Timecop.travel(Time.parse('2000/5/17'))
      assert_nil(@worker.holiday_greeting)
      Timecop.travel(Time.parse('2000/1/1'))
      assert(@worker.holiday_greeting.present?)
    end

    def test_topic
      assert(@worker.topic.present?)
    end

    def test_perform
      return if Environment.ci?
      Timecop.travel(Time.parse('2000/5/17'))
      @worker.perform
    end
  end
end
