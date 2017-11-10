namespace :db do

  desc "Trading bot"

  task :trade => :environment do

    # time = Time.now

    # until time.hour == 14 and time.min == 0
      stock_price = AlphavantageController.new.stock_price("FB")
      # p time.hour
      # p time.min
      # p stock_price

      test = Trade.new(symbol: "FB", price: stock_price, action: "BUY", quantity: 10)

      test.save

      # time = Time.now

      # sleep 60
    # end

  end




end
