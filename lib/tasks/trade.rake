namespace :db do

  desc "Trading bot"

  task :trade => :environment do

    # time = Time.now

    # until time.hour == 14 and time.min == 0
      symbol = "MSFT"
      quantity = 100
      stock_price = AlphavantageController.new.stock_price(symbol)
      # p time.hour
      # p time.min
      p stock_price

      trade = Trade.new(symbol: symbol, price: stock_price, action: "BUY", quantity: quantity)
      trade.save

      if Titre.where(symbol: symbol).exists? and trade.action == "BUY"
        titre = Titre.where(symbol: symbol)
        titre[0].increment!(:quantity, quantity)
        p "Titre updated (buy)"
      elsif Titre.where(symbol: symbol).exists? and trade.action == "SELL"
        titre = Titre.where(symbol: symbol)
        titre[0].decrement!(:quantity, quantity)
        p "Titre updated (sell)"
      else
        Titre.new(symbol: symbol, quantity: quantity).save
        p "Titre created"
      end


      # time = Time.now

      # sleep 60
    # end

  end




end
