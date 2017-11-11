class PortfolioController < ApplicationController

  def portfolio(portfolio = {})
    titres = Titre.all
    titres.each { |titre| portfolio[titre.symbol] = titre.quantity }
    return portfolio
  end



end
