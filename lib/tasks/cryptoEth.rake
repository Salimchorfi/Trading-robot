namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    require 'colorize'

    time = Time.now
    Cad.new(balance: 500).save
    EthBalance.new(balance: 1).save

    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter_eth = 1
    @initial_eth_balance = EthBalance.find(1).balance

    until time.hour == 24 and time.min == 50

      @eth_balance = EthBalance.find(1)
      @cad_balance = Cad.find(1)
      balanceC = @cad_balance.balance
      balanceE = @eth_balance.balance

      if Trade.where(symbol: "ETH", action: "BUY").count > 0
        @last_eth = Trade.where(symbol: "ETH", action: "BUY").last.price
      else
        @last_eth = 0
      end

      #Generate coins price ---------------------------------------------------

      #ETH
      if @regression_counter_eth == 1
        puts "#{@sub_ten} - Eth: #{eth = BitfinexController.new.stock_price("ethusd")}".light_blue
        puts ""
      else
        eth = BitfinexController.new.stock_price("ethusd")
      end

      #Create Etherum -----------------------------------------
      if Eth.count > 0
        if eth > 1
          Eth.new(price: eth, index: Eth.last.index + 1).save

          #Dynamic regression ----------------------------------------------------------
          if Eth.count > 30
            eth_slope = BitfinexController.new.eth_dynamic_regression(20)[0]
            eth_rsquared = BitfinexController.new.eth_dynamic_regression(20)[1]
            eth_long_slope = BitfinexController.new.eth_dynamic_regression(4)[0]

            if eth_rsquared > 0.8
              @regression_counter_eth += 1

              if eth_slope > 0
                puts "index: #{@regression_counter_eth} slope: #{eth_slope}, rsquared: #{eth_rsquared}, price: #{eth}, currency: ETH".black.on_light_green
              else
                puts "index: #{@regression_counter_eth} slope: #{eth_slope}, rsquared: #{eth_rsquared}, price: #{eth}, currency: ETH".black.on_light_red
              end

            elsif @regression_counter_eth > 1
              @regression_counter_eth = 1

              if eth_slope < - 0.3 and @cad_balance.balance > 0

                Trade.new(symbol: "ETH", price: eth, action: "BUY", quantity: (@cad_balance.balance / eth)).save

                EthBalance.find(1).increment!(:balance, by = (balanceC / eth))
                Cad.find(1).decrement!(:balance, by = (eth * (balanceC / eth)))

                puts "Baught #{(@cad_balance.balance / eth)} eth at #{eth}".cyan.bold
                puts "Eth volume: #{EthBalance.find(1).balance}".light_yellow.bold
                puts "Day balance: #{@initial_eth_balance - EthBalance.find(1).balance}".light_yellow.bold
                # @eth_balance.update_attribute(:balance, (balanceE + (balanceC / eth)))
                # @cad_balance.update_attribute(:balance, (balanceC - (eth * (balanceC / eth))))

              elsif eth_slope > 0.3 and @eth_balance.balance > 0 and Trade.where(symbol: "ETH").count == 0

                Trade.new(symbol: "ETH", price: eth, action: "SELL", quantity: @eth_balance.balance).save

                EthBalance.find(1).decrement!(:balance, by = balanceE)
                Cad.find(1).increment!(:balance, by = (eth * balanceE))

                puts "Sold #{@eth_balance.balance} eth at #{eth}".cyan.bold
                puts "Eth volume: #{EthBalance.find(1).balance}".light_yellow.bold
                puts "Day balance: #{@initial_eth_balance - EthBalance.find(1).balance}".light_yellow.bold
                # @eth_balance.update_attribute(:balance, (balanceE - balanceE))
                # @cad_balance.update_attribute(:balance, (balanceC + (eth * balanceE)))

              elsif eth_slope > 0.3 and @eth_balance.balance > 0 and eth > @last_eth

                Trade.new(symbol: "ETH", price: eth, action: "SELL", quantity: @eth_balance.balance).save

                EthBalance.find(1).decrement!(:balance, by = balanceE)
                Cad.find(1).increment!(:balance, by = (eth * balanceE))

                puts "Sold #{@eth_balance.balance} eth at #{eth}".cyan.bold
                puts "Eth volume: #{EthBalance.find(1).balance}".light_yellow.bold
                puts "Day balance: #{@initial_eth_balance - EthBalance.find(1).balance}".light_yellow.bold

              end

            else
              @regression_counter_eth = 1
            end

          end
        end
      else
        if eth > 1
          Eth.new(price: eth, index: 1).save
        end
      end

      # Increment variables
      time = Time.now
      @sub_ten += 1
      sleep 5

    end

  end


end
