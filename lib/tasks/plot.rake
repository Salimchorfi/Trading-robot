namespace :db do

  desc "Plot line"

  task :plot => :environment do

    require 'csv'

    csv = []

    filepath    = File.join(Rails.root, 'db', 'plot.csv')
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    x,y = Array.new(2) { [] }

    Btc.all.each do |btc|
      x << btc.index
      y << btc.price
    end


    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << x
      csv << y
    end


  end


end
