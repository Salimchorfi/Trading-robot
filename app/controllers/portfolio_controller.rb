class PortfolioController < ApplicationController

  def portfolio(portfolio = {})
    cad = Cad.find(1).balance
    btc = BtcBalance.find(1).balance
    btc_price = BitfinexController.new.stock_price("btcusd")

    return cad + (btc * btc_price)
  end



end
