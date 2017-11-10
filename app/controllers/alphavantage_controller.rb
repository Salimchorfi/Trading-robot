class AlphavantageController < ApplicationController

  require "httparty"
  @@base_uri = 'https://www.alphavantage.co'


  def stock_price(symbol)
    url = "query?function=TIME_SERIES_INTRADAY&symbol=#{symbol}&interval=1min&outputsize=compact&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Time Series (1min)"].first
  end

  def sma(symbol)
    url = "query?function=SMA&symbol=#{symbol}&interval=15min&time_period=10&series_type=close&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: SMA"].first
  end

  def stoch(symbol)
    url = "query?function=STOCH&symbol=#{symbol}&interval=15min&slowkmatype=1&slowdmatype=1&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: STOCH"].first
  end

  def macd(symbol)
    url = "query?function=MACD&symbol=#{symbol}&interval=15min&series_type=close&fastperiod=10&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: MACD"].first
  end

  def rsi(symbol)
    url = "query?function=RSI&symbol=#{symbol}&interval=15min&time_period=10&series_type=close&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: RSI"].first
  end

  def adx(symbol)
    url = "query?function=ADX&symbol=#{symbol}&interval=15min&time_period=10&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: ADX"].first
  end

  def cci(symbol)
    url = "query?function=CCI&symbol=#{symbol}&interval=daily&time_period=10&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: CCI"].first
  end

  def aroon(symbol)
    url = "query?function=AROON&symbol=#{symbol}&interval=daily&time_period=14&apikey=#{ENV["API_KEY"]}"
    response = HTTParty.get("#{@@base_uri}/#{url}")
    return response["Technical Analysis: AROON"].first
  end



end
