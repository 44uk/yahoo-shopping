# coding: utf-8

require 'pp'
require 'net/http'
require 'openssl'
require 'nokogiri'

module Yahoo
  class Shopping
    API_VERSION     = 'V1'
    SERVICE_URL     = 'http://shopping.yahooapis.jp/ShoppingWebService/'
    FORMATS         = [:php, :json]
    SORTS           = [:price, :name, :score, :sold, :affiliate, :review_count]
    AFFILIATE_TYPES = [:yid, :vc]
    TYPES           = [:all, :any]
    MODULES         = [:priceranges, :subcatefories]

    @@options = {
      :appid => nil,
      :ssl   => false,
      :strict=> false
    }
    @@debug = false

    class << self
      def configure(&block)
        raise ArgumentError, "Block is required." unless block_given?
        yield @@options
      end

      def options
        @@options
      end

      def options=(opts)
        @@options = opts
      end

      def debug
        @@debug
      end

      def debug=(dbg)
        @@debug = dbg
      end

      def item_search(opts)
        opts[:operation] = 'itemSearch'

        self.valid_params?(opts)
        self.send_request(opts)
      end

      def category_ranking(opts)
        opts[:operation] = 'categoryRanking'

        self.valid_params?(opts)
        self.send_request(opts)
      end

      def category_search(opts)
        opts[:operation] = 'categorySearch'

        self.valid_params?(opts)
        self.send_request(opts)
      end

      def item_lookup(opts)
        opts[:operation] = 'itemLookup'

        self.valid_params?(opts)
        self.send_request(opts)
      end

      def valid_params?(opts)
        operation = opts[:operation].gsub(/(_.)/) { $1.upcase.gsub(/\A_/, '') }

        case operation
        when 'itemSearch'
          requires = [
            :query, :jan, :isbn,
            :category_id, :product_id, :person_id, :brand_id, :store_id
          ]
        when 'categoryRanking'
          requires = []
        when 'categorySearch'
          requires = []
        when 'itemLookup'
          requires = [:itemcode]
        when 'queryRanking'
          requires = []
        when 'contentMatchItem'
          requires = [:url]
        when 'contentMatchRanking'
          requires = [:url]
        when 'getModule'
          requires = [:position]
        when 'eventSearch'
          requires = []
        when 'reviewSearch'
          requires = [
            :jan, :category_id, :product_id, :person_id, :store_id
          ]
        else
          raise 'Required :operation.'
        end

        valid = (requires - opts.keys).size < requires.size

        log "Operation #{opts[:operation]} with params is valid? => #{valid}"
        valid
      end

      def build_url(opts)
        request_url = "#{SERVICE_URL}#{API_VERSION}/"
        request_url.sub!(%r|\Ahttp://|, 'https://') if opts.delete(:ssl)

        request_url << "#{opts.delete(:format)}/" if FORMATS.include?(opts[:format])
        request_url << opts.delete(:operation)
        request_url << build_params(opts)

        request_url = URI.encode(request_url, /[^\-_.!~*'()a-zA-Z\d;\/?:@&=$,\[\]]/)

        log "build request url => #{request_url}"
        request_url
      end

      def build_params(opts)
        param_str = opts.each_with_object('') do |(k, v), str|
          str << "#{k}=#{v}&" unless v.nil?
        end

        '?' << param_str.chomp('&')
      end

      protected
      def send_request(opts)
        opts = self.options.merge(opts) if self.options

        req_url = build_url(opts)

        uri = URI::parse(req_url)

        http = Net::HTTP.new(uri.host, uri.port)
        if opts[:ssl]
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE # WARNING: SSL VERIFY NONE
        end

        log "request by this url => #{uri.request_uri}"
        req = Net::HTTP::Get.new(uri.request_uri)
        res = http.request(req)

        Response.new(res.body)
      end

      def log(str)
        return unless self.debug

        str = '[LOG] ' << str
        if defined? RAILS_DEFAULT_LOGGER
          RAILS_DEFAULT_LOGGER.error(str)
        elsif defined? LOGGER
          LOGGER.error(str)
        else
          puts str
        end
      end
    end

    class Response
      def initialize(xml)
        @doc = Nokogiri::XML(xml, nil, 'UTF-8')
        @doc.remove_namespaces!
      end

      def doc
        @doc
      end

      def query
        self.doc/'Query'
      end

      def items
        self.doc/'Hit'
      end

      def total_result_available
        self.doc/'ResultSet/@totalResultsAvailable'
      end

      def total_result_returned
        self.doc/'ResultSet/@totalResultsReturned'
      end

      def first_result_position
        self.doc/'ResultSet/@first_result_position'
      end
    end
  end
end
