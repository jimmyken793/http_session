#!/usr/bin/ruby
# encoding: utf-8

require 'iconv'
require 'net/http'
require 'uri'
require 'set'
require "addressable/uri"

class Hash
      def urlencode
          keys.inject('') do |query_string, key|
              query_string << '&' unless key == keys.first
              query_string << "#{URI.encode(key.to_s)}=#{URI.encode(self[key])}"
          end
      end
end
class HTTPSession
    attr_accessor :cookie

    def new
        @cookie={};
        rand_fake_ip
    end
	def rand_fake_ip
		@fake_ip='218.166.'+(1+rand(255)).to_s+'.'+(1+rand(255)).to_s
		puts 'new identity: '+@fake_ip
	end

	def get(url_str, params={}, header={})
		url=URI.parse(url_str)
		Net::HTTP.start(url.host) { |http|
            uri = Addressable::URI.new
            uri.query_values = @cookie
		    header['cookie'] = uri.query if uri.query != nil
            uri.query_values = params
			param = '?'+ uri.query
			if param=='?'
				param=''
			end
            puts url.path+param
            puts header
			resp=http.get(url.path+param,header)
			if resp['set-cookie']!= nil
                uri.query=resp['set-cookie'];
                if @cookie.nil?
                    @cookie = uri.query_values
                else
                    @cookie=@cookie.merge(uri.query_values)
                end
			end
			return resp.body
		}
	end

	def post(url_str, params={}, header={})
		url=URI.parse(url_str)
		Net::HTTP.start(url.host) { |http|
            uri = Addressable::URI.new
            uri.query_values = @cookie
            header['cookie'] = uri.query if uri.query != nil
            uri.query_values = params
            puts url.path
            puts uri.query
            puts header
			resp=http.post(url.path,uri.query,header)
			if resp['set-cookie']!=nil
				uri.query=resp['set-cookie'];
                if @cookie.nil?
                    @cookie = uri.query_values
                else
                    @cookie=@cookie.merge(uri.query_values)
                end
            end
			return resp.body
		}
	end

end

