namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    require 'colorize'

    time = Time.now
    BitfinexController.new.history

    @balanceB = BitfinexController.new.balance_btc
    @balanceC = BitfinexController.new.balance_usd
    BtcBalance.new(balance: @balanceB).save
    Cad.new(balance: @balanceC).save

    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter_btc = 1
    @initial_btc_balance = @balanceB

    until time.hour == 24 and time.min == 50

      #Validating last buy for price -----------------------
      if Trade.where(symbol: "BTC", action: "buy").count > 0
        @last_btc = Trade.where(symbol: "BTC", action: "buy").last.price
        @last_vol = Trade.where(symbol: "BTC", action: "buy").last.quantity
      else
        @last_btc = 0
        @last_vol = 0
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
          if Btc.count > 20
            slope = BitfinexController.new.btc_dynamic_regression(20)[0]
            rsquared = BitfinexController.new.btc_dynamic_regression(20)[1]
            short_slope = BitfinexController.new.btc_dynamic_regression(4)[0]

            if rsquared > 0.8
              @regression_counter_btc += 1

              if slope > 0
                puts "index: #{@regression_counter_btc} slope: #{slope}, rsquared: #{rsquared}, price: #{btc}, currency: BTC".black.on_light_green
              else
                puts "index: #{@regression_counter_btc} slope: #{slope}, rsquared: #{rsquared}, price: #{btc}, currency: BTC".black.on_light_red
              end

            elsif @regression_counter_btc > 1
              @regression_counter_btc = 1
              #Trade BUY ------------------------------------------------
              if slope < - 0.3 and @balanceC > 600

                if BitfinexController.new.negative_slope_confirmation(20, "btc")

                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd
                  BtcBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("btcusd", 0.04, "buy")
                  BitfinexController.new.history
                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd

                  puts "Baught #{((@balanceC - 20) / btc)} btc at #{btc}".cyan.bold
                  puts "Btc volume: #{@balanceB}".light_yellow.bold
                  if (@balanceB - @initial_btc_balance) > 0
                    puts "Day balance: #{@balanceB - @initial_btc_balance}".light_green.bold
                  else
                    puts "Day balance: #{@balanceB - @initial_btc_balance}".light_red.bold
                  end

                end

              #SELL ---------------------------------------------------------------
              elsif slope > 0.3 and @balanceB > 0.05 and Trade.last.action != "buy"

                if BitfinexController.new.positive_slope_confirmation(20, "btc") == true

                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd
                  BtcBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("btcusd", 0.04, "sell")
                  BitfinexController.new.history
                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_btc

                  puts "Sold #{@balanceB} btc at #{btc}".cyan.bold
                  puts "USD volume: #{@balanceC}".light_yellow.bold

                end

              #SELL ----------------------------------------------------
              elsif slope > 0.3 and @balanceB > 0.05 and btc > @last_btc

                if BitfinexController.new.positive_slope_confirmation(20, "btc")

                  @balanceB = BitfinexController.new.balance_btc
                  @balanceC = BitfinexController.new.balance_usd
                  BtcBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("btcusd", 0.04, "sell")
                  BitfinexController.new.history
                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_btc

                  puts "Sold #{@balanceB} btc at #{btc}".cyan.bold
                  puts "USD volume: #{@balanceC}".light_yellow.bold

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

      # Increment variables
      time = Time.now
      @sub_ten += 1
      sleep 10
      last_slope = slope

    end

  end


end
