namespace :db do

  desc "Crypto currencies bot"

  task :crypto => :environment do

    require 'colorize'

    time = Time.now
    BtcBalance.new(balance: 0.06250000).save
    Cad.new(balance: 500).save
    EthBalance.new(balance: 1).save
    # @btc_balance = 0.06250000
    # @cad_balance = 500
    @buy_commission = (0.1020 / 100)
    @sell_commission = (0.200 / 100)
    @sub_ten = 1
    @regression_counter_btc = 1
    @regression_counter_eth = 1

    until time.hour == 24 and time.min == 50

      @btc_balance = BtcBalance.find(1)
      @eth_balance = EthBalance.find(1)
      @cad_balance = Cad.find(1)
      balanceB = @btc_balance.balance
      balanceC = @cad_balance.balance
      balanceE = @eth_balance.balance

      if Trade.where(symbol: "BTC", action: "BUY").count > 0
        @last_btc = Trade.where(symbol: "BTC", action: "BUY").last.price
        @last_eth = Trade.where(symbol: "ETH", action: "BUY").last.price
      else
        @last_btc = 0
        @last_eth = 0
      end

      #Generate coins price ---------------------------------------------------
      #BTC
      if @regression_counter_btc == 1
        puts "#{@sub_ten} - Btc: #{btc = BitfinexController.new.stock_price("btcusd")}".light_blue
      else
        btc = BitfinexController.new.stock_price("btcusd")
      end

      #ETH
      if @regression_counter_eth == 1
        puts "#{@sub_ten} - Eth: #{eth = BitfinexController.new.stock_price("ethusd")}".light_blue
        puts ""
      else
        eth = BitfinexController.new.stock_price("ethusd")
      end

      #Create Bitcoin -----------------------------------------
      if Btc.count > 0
        if btc > 1
          Btc.new(price: btc, index: Btc.last.index + 1).save

          #Dynamic regression ----------------------------------------------------------
          if Btc.count > 30
            slope = BitfinexController.new.btc_dynamic_regression(30)[0]
            rsquared = BitfinexController.new.btc_dynamic_regression(30)[1]
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

              if slope < - 0.3 and @cad_balance.balance > 0 and rsquared > 0.8
                puts "Baught #{(@cad_balance.balance / btc)} btc at #{btc}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Btc: #{PortfolioController.new.btc_volume}".light_yellow.bold

                Trade.new(symbol: "BTC", price: btc, action: "BUY", quantity: (@cad_balance.balance / btc)).save

                @btc_balance.update_attribute(:balance, (balanceB + (balanceC / btc)))
                @cad_balance.update_attribute(:balance, (balanceC - (btc * (balanceC / btc))))

              elsif slope > 0.3 and @btc_balance.balance > 0 and Trade.count == 0
                puts "Sold #{@btc_balance.balance} btc at #{btc}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Btc: #{PortfolioController.new.btc_volume}".light_yellow.bold

                Trade.new(symbol: "BTC", price: btc, action: "SELL", quantity: @btc_balance.balance).save

                @btc_balance.update_attribute(:balance, (balanceB - balanceB))
                @cad_balance.update_attribute(:balance, (balanceC + (btc * balanceB)))

              elsif slope > 0.3 and @btc_balance.balance > 0 and btc > @last_btc
                puts "Sold #{@btc_balance.balance} btc at #{btc}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Btc: #{PortfolioController.new.btc_volume}".light_yellow.bold

                Trade.new(symbol: "BTC", price: btc, action: "SELL", quantity: @btc_balance.balance).save

                @btc_balance.update_attribute(:balance, (balanceB - balanceB))
                @cad_balance.update_attribute(:balance, (balanceC + (btc * balanceB)))

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

      #Create Etherum -----------------------------------------
      if Eth.count > 0
        if eth > 1
          Eth.new(price: eth, index: Eth.last.index + 1).save

          #Dynamic regression ----------------------------------------------------------
          if Eth.count > 30
            eth_slope = BitfinexController.new.eth_dynamic_regression(30)[0]
            eth_rsquared = BitfinexController.new.eth_dynamic_regression(30)[1]
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

              if eth_slope < - 0.3 and @cad_balance.balance > 0 and eth_rsquared > 0.8
                puts "Baught #{(@cad_balance.balance / eth)} eth at #{eth}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Eth: #{PortfolioController.new.eth_volume}".light_yellow.bold

                Trade.new(symbol: "ETH", price: eth, action: "BUY", quantity: (@cad_balance.balance / eth)).save

                @eth_balance.update_attribute(:balance, (balanceE + (balanceC / eth)))
                @cad_balance.update_attribute(:balance, (balanceC - (eth * (balanceC / eth))))

              elsif eth_slope > 0.3 and @eth_balance.balance > 0 and Trade.count == 0
                puts "Sold #{@eth_balance.balance} eth at #{eth}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Eth: #{PortfolioController.new.eth_volume}".light_yellow.bold

                Trade.new(symbol: "ETH", price: eth, action: "SELL", quantity: @eth_balance.balance).save

                @eth_balance.update_attribute(:balance, (balanceE - balanceE))
                @cad_balance.update_attribute(:balance, (balanceC + (eth * balanceE)))

              elsif eth_slope > 0.3 and @eth_balance.balance > 0 and eth > @last_eth
                puts "Sold #{@eth_balance.balance} eth at #{eth}".cyan.bold
                puts "Portfolio value: #{PortfolioController.new.portfolio}$".light_yellow.bold
                puts "Eth: #{PortfolioController.new.eth_volume}".light_yellow.bold

                Trade.new(symbol: "ETH", price: eth, action: "SELL", quantity: @eth_balance.balance).save

                @eth_balance.update_attribute(:balance, (balanceE - balanceE))
                @cad_balance.update_attribute(:balance, (balanceC + (eth * balanceE)))

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
      sleep 10

    end

  end


end
