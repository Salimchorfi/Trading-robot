class PortfolioController < ApplicationController

  def portfolio(portfolio = {})
    titres = Titre.all
    titres.each { |titre| portfolio[titre.symbol] = titre.quantity }
    return portfolio
  end

  def btc_portfolio(portfolio = {})
    volume = 0
    Trade.all do |trade|
      if trade.action = "BUY"
        volume += trade.quantity
      elsif trade.action = "SELL"
        volume -= trade.quantity
      end
      return volume
    end


  end



end
