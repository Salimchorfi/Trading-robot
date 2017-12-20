namespace :db do

  desc "Crypto currencies bot"

  task :cryptoBch => :environment do

    require 'colorize'

    time = Time.now
    BitfinexController.new.history

    @balanceB = BitfinexController.new.balance_bch
    @balanceC = BitfinexController.new.balance_usd
    BchBalance.new(balance: @balanceB).save
    Cad.new(balance: @balanceC).save

    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter_bch = 1
    @initial_bch_balance = @balanceB

    until time.hour == 24 and time.min == 50

      #Validating last buy for price -----------------------
      if Trade.where(symbol: "BCH", action: "buy").count > 0
        @last_bch = Trade.where(symbol: "BCH", action: "buy").last.price
        @last_vol = Trade.where(symbol: "BCH", action: "buy").last.quantity
      else
        @last_bch = 0
        @last_vol = 0
      end

      #Generate coins price ---------
      #BTC
      if @regression_counter_bch == 1
        puts "#{@sub_ten} - Bch: #{bch = BitfinexController.new.stock_price("bchusd")}".light_blue
      else
        bch = BitfinexController.new.stock_price("bchusd")
      end

      #Create Bitcoin ---------------------------------------
      if Bch.count > 0
        if bch > 1
          Bch.new(price: bch, index: Bch.last.index + 1).save

          #Dynamic regression ------------------------------------------
          if Bch.count > 20
            slope = BitfinexController.new.bch_dynamic_regression(20)[0]
            rsquared = BitfinexController.new.bch_dynamic_regression(20)[1]
            short_slope = BitfinexController.new.bch_dynamic_regression(4)[0]

            if rsquared > 0.8
              @regression_counter_bch += 1

              if slope > 0
                puts "index: #{@regression_counter_bch} slope: #{slope}, rsquared: #{rsquared}, price: #{bch}, currency: BCH".black.on_light_green
              else
                puts "index: #{@regression_counter_bch} slope: #{slope}, rsquared: #{rsquared}, price: #{bch}, currency: BCH".black.on_light_red
              end

            elsif @regression_counter_bch > 1
              @regression_counter_bch = 1
              #Trade BUY ------------------------------------------------
              if slope < - 0.3 and @balanceC > 600

                if BitfinexController.new.negative_slope_confirmation(20, "bch")

                  @balanceB = BitfinexController.new.balance_bch
                  @balanceC = BitfinexController.new.balance_usd
                  BchBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("bchusd", 0.04, "buy")
                  BitfinexController.new.history
                  @balanceB = BitfinexController.new.balance_bch
                  @balanceC = BitfinexController.new.balance_usd

                  puts "Baught #{(0.04 / bch)} bch at #{bch}".cyan.bold
                  puts "Bch volume: #{@balanceB}".light_yellow.bold
                  if (@balanceB - @initial_bch_balance) > 0
                    puts "Day balance: #{@balanceB - @initial_bch_balance}".light_green.bold
                  else
                    puts "Day balance: #{@balanceB - @initial_bch_balance}".light_red.bold
                  end

                end

              #SELL ---------------------------------------------------------------
              elsif slope > 0.3 and @balanceB > 0.05 and Trade.last.action != "buy"

                if BitfinexController.new.positive_slope_confirmation(20, "bch") == true

                  @balanceB = BitfinexController.new.balance_bch
                  @balanceC = BitfinexController.new.balance_usd
                  BchBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("bchusd", 0.04, "sell")
                  BitfinexController.new.history
                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_bch

                  puts "Sold #{@balanceB} bch at #{bch}".cyan.bold
                  puts "USD volume: #{@balanceC}".light_yellow.bold

                end

              #SELL ----------------------------------------------------
              elsif slope > 0.3 and @balanceB > 0.05 and bch > @last_bch

                if BitfinexController.new.positive_slope_confirmation(20, "bch")

                  @balanceB = BitfinexController.new.balance_bch
                  @balanceC = BitfinexController.new.balance_usd
                  BchBalance.find(1).update_attribute(:balance, @balanceB)
                  Cad.find(1).update_attribute(:balance, @balanceC)

                  BitfinexController.new.order("bchusd", 0.04, "sell")
                  BitfinexController.new.history
                  @balanceC = BitfinexController.new.balance_usd
                  @balanceB = BitfinexController.new.balance_bch

                  puts "Sold #{@balanceB} bch at #{bch}".cyan.bold
                  puts "USD volume: #{@balanceC}".light_yellow.bold

                end

              end

            else
              @regression_counter_bch = 1
            end

          end
        end
      else
        if bch > 1
          Bch.new(price: bch, index: 1).save
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
