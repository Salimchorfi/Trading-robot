namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    time = Time.now
    btc_balance = 0.06250000
    buy_commission = (0.100 / 100)
    sell_commission = (0.200 / 100)
    @sub_ten = 1

    until time.hour == 24 and time.min == 50


      p "#{@sub_ten} - #{btc = BitfinexController.new.stock_price("btcusd")}"

      if Btc.count > 0
        Btc.new(price: btc, index: Btc.last.index + 1).save
      else
        Btc.new(price: btc, index: 1).save
      end

      # trade = Trade.new(symbol: "BTC", price: btc, action: "BUY", quantity: 1)
      # p btc

      if @sub_ten % 80 == 0
        p BitfinexController.new.line_fit
      end

      time = Time.now
      @sub_ten += 1
      sleep 15

    end

  end


end
