class BitfinexController < ApplicationController
  require "httparty"

  Bitfinex::Client.configure do |conf|

    conf.secret = ENV["BFX_API_SECRET"]
    conf.api_key = ENV["BFX_API_KEY"]

  end

  #client = Bitfinex::Client.new

  @@base_uri = 'https://api.bitfinex.com/v1'


  def stock_price(symbol)
    url = "pubticker/#{symbol}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["last_price"].to_f
  end

  def btc_slope(ind)
    first = Btc.find(ind)
    second = Btc.find(ind - 9)

    p x1 = first.index
    p y1 = first.price

    p x2 = second.index
    p y2 = second.price

    return m = (y2 - y1) / (x2 - x1)
  end


end
