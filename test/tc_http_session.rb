#!/usr/bin/ruby
require "./http_session"
require 'test/unit'

class HTTPSessionTest < Test::Unit::TestCase
    def setup
        @session = HTTPSession.new
    end

    def teardown
    end
    def test_range
        puts @session.cookie
        assert_nothing_raised{
            @session.get("http://www.google.com.tw/");
        }
        assert_nothing_raised{
            @session.post("http://www.google.com.tw/");
        }
    end
end

