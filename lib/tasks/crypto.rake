namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    time = Time.now
    btc_balance = 0.06250000
    buy_commission = (0.100 / 100)
    sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter = 1

    until time.hour == 24 and time.min == 50

      #Generate coins price ---------------------------------------------------
      p "#{@sub_ten} - #{btc = BitfinexController.new.stock_price("btcusd")} - regression = #{@regression_counter}"
      # p "#{@sub_ten} - #{eth = BitfinexController.new.stock_price("ethusd")}"

      #Create Bitcoin -----------------------------------------
      if Btc.count > 0
        if btc > 1
          Btc.new(price: btc, index: Btc.last.index + 1).save

          #Dynamic regression ----------------------------------------------------------
          if Btc.count > 20
            slope = BitfinexController.new.dynamic_regression(20 + @regression_counter)[0]
            rsquared = BitfinexController.new.dynamic_regression(20 + @regression_counter)[1]
            if rsquared > 0.85
              @regression_counter += 1
              p "index = #{@regression_counter} slope = #{slope}, rsquared = #{rsquared}"
            else
              @regression_counter = 1
            end
          end

        end
        # if eth > 1
        #   Eth.new(price: eth, index: Eth.last.index + 1).save
        # end
      else
        if btc > 1
          Btc.new(price: btc, index: 1).save
        end
        # if eth > 1
        #   Eth.new(price: eth, index: 1).save
        # end
      end

      #Dynamic regression ----------------------------------------------------------
      # if Btc.count > 2
      #   slope = BitfinexController.new.dynamic_regression(@regression_counter)[0]
      #   rsquared = BitfinexController.new.dynamic_regression(@regression_counter)[1]
      #   if rsquared > 0.8
      #     @regression_counter += 1
      #     p "slope = #{slope}, rsquared = #{rsquared}"
      #   else
      #     @regression_counter = 1
      #   end
      # else
      #   @regression_counter += 1
      # end

      # Create trade -----------------------------------------------------------
      # trade = Trade.new(symbol: "BTC", price: btc, action: "BUY", quantity: 1)
      # p btc

      #Fixed regression ------------------------------------------------------------
      # if @sub_ten % 40 == 0
      #   slope = BitfinexController.new.line_fit_40[0]
      #   rsquared = BitfinexController.new.line_fit_40[1]
      #   Regression.new(slope: slope, rsquared: rsquared, index: Btc.last.index).save
      #   p "slope = #{slope}, rsquared = #{rsquared}"
      # end

      # Increment variables
      time = Time.now
      @sub_ten += 1
      sleep 15

    end

  end


end
