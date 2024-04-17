# pull in neccesary libraries
require 'csv'
require_relative 'cell_class.rb'

#user input get function
def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

#use read_csv function for pulling in data
def read_csv(filename)
  cells = []
  CSV.foreach(filename, headers: true) do |row|
    cell = Cell.new(row)
    cell.clean_data
    cell.replace_with_null #replace all missing or "-" values with null or something similar that can be ignored during calculations
    cells << cell
  end

  cells
end