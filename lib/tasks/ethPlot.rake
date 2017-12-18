namespace :db do

  desc "Plot line"

  task :ethPlot => :environment do

    require 'csv'

    csv = []

    filepath    = File.join(Rails.root, 'db', 'eth_plot.csv')
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    x,y = Array.new(2) { [] }

    Eth.all.each do |eth|
      x << eth.index
      y << eth.price.to_i
    end

    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << x
      csv << y
    end


  end


end
