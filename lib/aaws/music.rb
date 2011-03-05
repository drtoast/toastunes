require 'net/http'
require 'cgi'
require 'hmac-sha2'

# aaws = AAWS::Music.new
# result = aaws.search(:query => {:artist => 'Radiohead', :keywords => 'In Rainbows'})
# url = result['ItemSearchResponse']['Items']['Item'][0]['LargeImage']['URL']
# covers = aaws.covers(:query => {:artist => 'Radiohead', :keywords => 'In Rainbows'})
# covers[0][:large]

module AAWS
  class Music
    include HTTParty
    
    attr_accessor :error
    
    AMAZON_HOST = 'webservices.amazon.com' #'ecs.amazonaws.com'
    base_uri "http://#{AMAZON_HOST}"
    # can't use httparty's default_params class method because we need to access these in signature_for
    DEFAULT_PARAMS = {
      'Service' => 'AWSECommerceService',
      'Operation' => 'ItemSearch',
      'SearchIndex' => 'Music',
      'ResponseGroup' => 'Images',
      'AWSAccessKeyId' => Toastunes::Application.config.amazon_access_key_id
    }
    
    def initialize
    end
    
    def search(options={})
      raise ArgumentError, 'You must search for something' if options[:query].blank?
      options[:query] = add_signature(options[:query])

      # make a request and return the items (NOTE: this doesn't handle errors at this point)
      # result['ItemSearchResponse']['Items']['Item'][0]['LargeImage']['URL'] or MediumImage, SmallImage
      self.class.get('/onca/xml', options)
    end
    
    def covers(options={})
      result = search(options)
      
      if result['ItemSearchResponse'] and result['ItemSearchResponse']['Items'] and result['ItemSearchResponse']['Items']['Item']
        covers = []
        items = result['ItemSearchResponse']['Items']['Item']
        items = [items] if items.is_a?(Hash)
        items.each do |item|
          next unless item['LargeImage']
          covers << {
            :small => item['SmallImage'] ? item['SmallImage']['URL'] : nil,
            :medium => item['MediumImage'] ? item['MediumImage']['URL'] : nil,
            :large => item['LargeImage'] ? item['LargeImage']['URL'] : nil,
          }
        end
        return covers
      else
        @error = result['ItemSearchResponse']['Items']['Request']['Errors']['Error']['Message']
        return []
      end
    end
    
    private
    
    def add_signature(query)
      # http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/index.html?rest-signature.html
      # http://umlaut.rubyforge.org/svn/trunk/lib/aws_product_sign.rb
      # https://github.com/topfunky/ruby-hmac/blob/master/test/test_hmac.rb
      
      # camelize param keys
      query = query.inject({}) { |h, q| h[q[0].to_s.camelize] = q[1]; h }
      
      # add default params
      query = query.merge(DEFAULT_PARAMS)
      
      # add timestamp
      query['Timestamp'] = Time.now.utc.xmlschema
      
      # sort query by keys, url encode keys and values
      canonical = query.keys.sort.collect{|key|  [url_encode(key), url_encode(query[key].to_s)].join("=") }.join("&")
      
      # generate HMAC signature
      hmac = HMAC::SHA256.new(Toastunes::Application.config.amazon_secret_access_key)
      hmac.update(["GET", AMAZON_HOST, '/onca/xml', canonical].join("\n"))
      query['Signature'] = Base64.encode64(hmac.digest).chomp # hmac.hexdigest
      
      return query
    end
    
    # sort query by keys, url encode keys and values

    # Insist on specific method of URL encoding, RFC3986. 
    def url_encode(string)
      # It's kinda like CGI.escape, except CGI.escape is encoding a tilde when
      # it ought not to be, so we turn it back. Also space NEEDS to be %20 not +.
      return CGI.escape(string).gsub("%7E", "~").gsub("+", "%20")
    end

    
  end
end
