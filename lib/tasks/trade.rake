namespace :db do

  desc "Trading bot"

  task :trade => :environment do

    require 'colorize'

    Trade.all.each do |trade|
      puts "#{trade.action}".light_yellow.bold + " #{trade.quantity} at #{trade.price}".light_white
    end

  end




end
