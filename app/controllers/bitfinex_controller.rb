class BitfinexController < ApplicationController
  require "httparty"
  require "ascii_charts"
  require "linefit"

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

  def price_volume(symbol)
    url = "pubticker/#{symbol}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["volume"].to_f
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

  def plot(ind)
    first = Btc.find(ind)
    second = Btc.find(ind - 9)

    p x1 = first.index
    p y1 = first.price / 6000

    p x2 = second.index
    p y2 = second.price / 6000
    puts AsciiCharts::Cartesian.new([[x1, y1], [x2, y2]]).draw
  end

  def line_fit
    x,y = Array.new(2) { [] }

    Btc.last(80).each do |btc|
      x << btc.index
      y << btc.price
    end

    lineFit = LineFit.new
    lineFit.setData(x,y)

    # p slope = lineFit.coefficients[1]
    # p lineFit.rSquared
    # p lineFit.meanSqError
    # p lineFit.durbinWatson
    # p lineFit.sigma

    return [lineFit.coefficients[1], lineFit.rSquared]
  end

end
