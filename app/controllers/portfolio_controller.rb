class PortfolioController < ApplicationController

  def portfolio
    cad = Cad.find(1).balance
    btc = BtcBalance.find(1).balance
    btc_price = BitfinexController.new.stock_price("btcusd")

    return cad + (btc * btc_price)
  end

  def btc_volume
    cad = Cad.find(1).balance
    btc = BtcBalance.find(1).balance
    btc_price = BitfinexController.new.stock_price("btcusd")
    vol = btc + (cad / btc_price)
    return vol
  end

  def eth_volume
    cad = Cad.find(1).balance
    eth = EthBalance.find(1).balance
    eth_price = BitfinexController.new.stock_price("ethusd")
    vol = eth + (cad / eth_price)
    return vol
  end
end
