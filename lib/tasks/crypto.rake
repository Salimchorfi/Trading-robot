namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    time = Time.now
    btc_balance = 0.06250000
    buy_commission = (0.100 / 100)
    sell_commission = (0.200 / 100)
    @sub_ten = 1

    until time.hour == 24 and time.min == 50


      p "#{@sub_ten} - #{btc = BitfinexController.new.stock_price("ethusd")}"

      if Btc.count > 0
        Btc.new(price: btc, index: Btc.last.index + 1).save
      else
        Btc.new(price: btc, index: 1).save
      end

      # trade = Trade.new(symbol: "BTC", price: btc, action: "BUY", quantity: 1)
      # p btc

      if @sub_ten % 40 == 0
        slope = BitfinexController.new.line_fit_40[0]
        rsquared = BitfinexController.new.line_fit_40[1]
        Regression.new(slope: slope, rsquared: rsquared, index: Btc.last.index).save
        p "slope = #{slope}, rsquared = #{rsquared}"
      end

      time = Time.now
      @sub_ten += 1
      sleep 15

    end

  end


end
