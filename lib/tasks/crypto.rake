namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    require 'colorize'

    @balanceB = BitfinexController.new.balance_btc
    @balanceC = BitfinexController.new.balance_usd

    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter_btc = 1
    @initial_btc_balance = @balanceB
    @last_slope = 0
    stop = "no"


    puts "Btc balance: #{@balanceB} Usd balance: #{@balanceC}"

    until stop == "yes"

      #Validating last buy for price -----------------------
      if Trade.where(symbol: "BTC", action: "buy").count > 0
        @last_buy = Trade.where(symbol: "BTC", action: "buy").last.price
        @last_sell = Trade.where(symbol: "BTC", action: "sell").last.price
        @last_vol = Trade.where(symbol: "BTC", action: "buy").last.quantity
      else
        @last_btc = 0
        @last_vol = 0
        @last_sell = 50000
      end

      #@last_trade = [Trade.first.action, Trade.first.price] if Trade.count > 0

      if Trade.count > 0
        p @last_trade = [Trade.first.action, Trade.first.price]
      end


      #Generate coins price ---------
      #BTC
      if @regression_counter_btc == 1
        puts "#{@sub_ten} - Btc: #{btc = BitfinexController.new.stock_price("btcusd")}".light_blue
      else
        btc = BitfinexController.new.stock_price("btcusd")
      end

      #Create Bitcoin ---------------------------------------
      if Btc.count > 0
        if btc > 1
          Btc.new(price: btc, index: Btc.last.index + 1).save

          #Dynamic regression ------------------------------------------
          if Btc.count > 35
            slopeBuy = BitfinexController.new.btc_dynamic_regression(20)[0]
            rsquaredBuy = BitfinexController.new.btc_dynamic_regression(20)[1]
            slopeSell = BitfinexController.new.btc_dynamic_regression(35)[0]
            rsquaredSell = BitfinexController.new.btc_dynamic_regression(35)[1]

            puts "slopeBuy: #{slopeBuy} rsquaredBuy: #{rsquaredBuy}"
            puts "slopeSell: #{slopeSell} rsquaredSell: #{rsquaredSell}"
            btc = BitfinexController.new.stock_price("btcusd")

            if rsquaredBuy > 0.8 and slopeBuy < 0 || (slopeBuy < - 5 and slope < @last_slope_buy)
              @regression_counter_btc += 1
              puts "slopeBuy: #{slopeBuy}, rsquaredBuy: #{rsquaredBuy}, price: #{btc}, currency: BTC".black.on_light_red

            elsif rsquaredSell > 0.8 and slopeSell > 0 || (slopeSell > 5 and slope > @last_slope_sell)
              @regression_counter_btc += 1
              puts "slopeSell: #{slopeSell}, rsquaredSell: #{rsquaredSell}, price: #{btc}, currency: BTC".black.on_light_green


            elsif @regression_counter_btc > 1

              @regression_counter_btc = 1
              #Trade BUY -------------------------------------------------------------------------------------------
              if slopeBuy < - 0.3 and @balanceC > (0.08 * btc) and Trade.count == 0

                if BitfinexController.new.negative_slope_confirmation(20, "btc")

                  BitfinexController.new.order("btcusd", 0.08, "buy")

                  sleep 5

                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd
                  BitfinexController.new.history

                  puts "Baught #{((@balanceC - 20) / btc)} btc at #{btc}".cyan.bold
                  puts "Btc balance: #{@balanceB} Usd balance: #{@balanceC}".light_yellow

                end

              #Trade BUY --------------------------------------------------------------------------------------------------
              elsif slopeBuy < - 0.3 and @balanceC > (0.08 * btc) and @last_trade[0] == "sell" and btc < @last_trade[1]

                if BitfinexController.new.negative_slope_confirmation(20, "btc")

                  BitfinexController.new.order("btcusd", 0.08, "buy")

                  sleep 5

                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd
                  BitfinexController.new.history

                  puts "Baught #{((@balanceC - 20) / btc)} btc at #{btc}".cyan.bold
                  puts "Btc balance: #{@balanceB} Usd balance: #{@balanceC}".light_yellow

                end

              #SELL ---------------------------------------------------------------
              elsif slopeSell > 0.3 and @balanceB > 0.09 and Trade.count == 0

                if BitfinexController.new.positive_slope_confirmation(20, "btc")

                  BitfinexController.new.order("btcusd", 0.08, "sell")

                  sleep 5

                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_btc
                  BitfinexController.new.history

                  puts "Sold #{@balanceB} btc at #{btc}".cyan.bold
                  puts "Btc balance: #{@balanceB} Usd balance: #{@balanceC}".light_yellow

                end

              #SELL ----------------------------------------------------
              elsif slopeSell > 0.3 and @balanceB > 0.09 and @last_trade[0] == "buy" and btc > @last_trade[1]

                if BitfinexController.new.positive_slope_confirmation(20, "btc")

                  BitfinexController.new.order("btcusd", 0.08, "sell")

                  sleep 5

                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_btc
                  BitfinexController.new.history

                  puts "Sold #{@balanceB} btc at #{btc}".cyan.bold
                  puts "Btc balance: #{@balanceB} Usd balance: #{@balanceC}"

                end

              end

            else
              @regression_counter_btc = 1
            end

          end
        end
      else
        if btc > 1
          Btc.new(price: btc, index: 1).save
        end
      end

      # Increment/update variables
      @sub_ten += 1
      @last_slope_buy = slopeBuy
      @last_slope_sell = slopeSell
      sleep 10


    end

  end


end
