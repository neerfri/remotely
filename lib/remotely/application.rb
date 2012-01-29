module Remotely
  class Application
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @connection_setup = Proc.new do |b|
        b.request :url_encoded
        b.adapter :net_http
      end
      instance_eval(&block)
    end

    # Set or get the applications base url.
    #
    # @param [String] url Base url to the appplication
    #
    def url(url=nil)
      return @url unless url
      @url = URI.parse(set_scheme(url)).to_s
    end

    # Set or get BasicAuth credentials.
    #
    # @param [String] user BasicAuth user
    # @param [String] password BasicAuth password
    #
    def basic_auth(user=nil, password=nil)
      return @basic_auth unless user && password
      @basic_auth = [user, password]
    end

    # Set or get Faraday connection setup block.
    #
    # @yield [builder] A block that will be used when initializing faraday connection
    # @yieldparam [builder] The Faraday builder object
    #
    def connection_setup(&block)
      return @connection_setup unless block
      @connection_setup = block
    end

    # Connection to the application (with BasicAuth if it was set).
    #
    def connection
      return unless @url

      @connection ||= Faraday::Connection.new(@url, &connection_setup)

      @connection.basic_auth(*@basic_auth) if @basic_auth
      @connection
    end

  private

    def set_scheme(url)
      url =~ /^http/ ? url : "http://#{url}"
    end
  end
end
