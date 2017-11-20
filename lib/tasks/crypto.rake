namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    require 'colorize'

    time = Time.now
    BtcBalance.new(balance: 0.06250000).save
    Cad.new(balance: 500).save
    # @btc_balance = 0.06250000
    # @cad_balance = 500
    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter = 1

    until time.hour == 24 and time.min == 50

      @btc_balance = BtcBalance.find(1)
      @cad_balance = Cad.find(1)
      balanceB = @btc_balance.balance
      balanceC = @cad_balance.balance

      puts "Cad: #{@cad_balance.balance},  Btc: #{@btc_balance.balance}"

      #Generate coins price ---------------------------------------------------
      puts "#{@sub_ten} - #{btc = BitfinexController.new.stock_price("btcusd")} - regression = #{@regression_counter}"
      # p "#{@sub_ten} - #{eth = BitfinexController.new.stock_price("ethusd")}"

      #Create Bitcoin -----------------------------------------
      if Btc.count > 0
        if btc > 1
          Btc.new(price: btc, index: Btc.last.index + 1).save

          #Dynamic regression ----------------------------------------------------------
          if Btc.count > 20
            slope = BitfinexController.new.dynamic_regression(20)[0]
            rsquared = BitfinexController.new.dynamic_regression(20)[1]
            short_rsquared = BitfinexController.new.dynamic_regression(5)[1]

            if rsquared > 0.85 and short_rsquared > 0.8
              @regression_counter += 1

              if slope > 0
                puts "index = #{@regression_counter} slope = #{slope}, rsquared = #{rsquared}".black.on_green
              else
                puts "index = #{@regression_counter} slope = #{slope}, rsquared = #{rsquared}".black.on_red
              end

            elsif @regression_counter > 1
              @regression_counter = 1

              if slope < - 0.5 and @cad_balance.balance > 0
                puts "Baught #{(@cad_balance.balance / btc)} btc at #{btc}".cyan.bold
                Trade.new(symbol: "BTC", price: btc, action: "BUY", quantity: (@cad_balance.balance / btc)).save

                @btc_balance.update_attribute(:balance, (balanceB + (balanceC / btc)))
                @cad_balance.update_attribute(:balance, (balanceC - (btc * (balanceC / btc))))

              elsif slope > 0.5 and @btc_balance.balance > 0 and Trade.count == 0
                puts "Sold #{@btc_balance.balance} btc at #{btc}".cyan.bold
                Trade.new(symbol: "BTC", price: btc, action: "SELL", quantity: @btc_balance.balance).save

                @btc_balance.update_attribute(:balance, (balanceB - balanceB))
                @cad_balance.update_attribute(:balance, (balanceC + (btc * (balanceC / btc))))

              elsif slope > 0.5 and @btc_balance.balance > 0 and btc > Trade.where(action: "BUY").last.price
                puts "Sold #{@btc_balance.balance} btc at #{btc}".cyan.bold
                Trade.new(symbol: "BTC", price: btc, action: "SELL", quantity: @btc_balance.balance).save

                @btc_balance.update_attribute(:balance, (balanceB - balanceB))
                @cad_balance.update_attribute(:balance, (balanceC + (btc * (balanceC / btc))))

              end

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
