module Makoto
  class QuoteLibTest < Test::Unit::TestCase
    def setup
      @config = Config.instance
      @lib = QuoteLib.new
      @lib.refresh
    end

    def test_exist?
      assert(@lib.exist?)
    end

    def test_path
      assert(@lib.path.present?)
    end

    def test_quotes
      return if Environment.ci?
      assert(@lib.quotes.is_a?(Array))
      @lib.quotes(detail: true)[0..10].each do |quote|
        assert(quote['series'].is_a?(String))
        assert(quote['episode'].positive?)
        assert(quote['quote'].is_a?(String))
        assert(quote['quote'].present?)
      end
    end

    def test_keep?
      params = {
        priority: @config['/quote/priority/min'],
        form: ['剣崎真琴', 'キュアソード'],
        keyword: '',
      }
      entry = {
        'series' => 'ドキドキ!プリキュア',
        'episode' => 1,
        'quote' => '何も守れなかった…。何も…。',
        'emotion' => '',
        'exclude' => '',
        'priority' => 4,
        'form' => 'キュアソード',
        'remark' => '',
      }
      assert(@lib.keep?(entry, params))

      entry['exclude'] = 1
      assert_false(@lib.keep?(entry, params))

      entry['exclude'] = nil
      params[:emotion] = :bad
      assert_false(@lib.keep?(entry, params))

      entry['emotion'] = 'bad'
      assert(@lib.keep?(entry, params))

      params[:emotion] = nil
      assert_false(@lib.keep?(entry, params))

      params[:priority] = 4
      entry['emotion'] = ''
      assert(@lib.keep?(entry, params))

      params[:priority] = 5
      assert_false(@lib.keep?(entry, params))

      params[:form] = ['剣崎真琴']
      params[:priority] = 4
      assert_false(@lib.keep?(entry, params))

      params[:keyword] = '守れなかった'
      params[:form] = ['キュアソード']
      assert(@lib.keep?(entry, params))

      params[:keyword] = '守れかった'
      assert_false(@lib.keep?(entry, params))
    end
  end
end
