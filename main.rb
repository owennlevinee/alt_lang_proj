#pull in neccesary libraries
require 'csv'

#define top level vars
print_cells = 1


#create cell class
class Cell
  attr_accessor :oem, :model, :launch_announced, :launch_status, :body_dimensions, :body_weight, :body_sim, :display_type, :display_size, :display_resolution, :features_sensors, :platform_os

  def initialize(data)
    @oem = data[0]
    @model = data[1]
    @launch_announced = data[2]
    @launch_status = data[3]
    @body_dimensions = data[4]
    @body_weight = data[5]
    @body_sim = data[6]
    @display_type = data[7]
    @display_size = data[8]
    @display_resolution = data[9]
    @features_sensors = data[10]
    @platform_os = data[11]
  end
  
  def clean_data
    clean_launch_announced
    clean_launch_status
    clean_body_dimensions
    clean_body_weight
    clean_body_sim
    clean_display_resolution
    clean_features_sensors
    clean_platform_os
  end

  def clean_launch_announced
    @launch_announced = @launch_announced.scan(/\d{4}/).first if @launch_announced =~ /\d{4}/
    @launch_announced = nil if @launch_announced.nil? || @launch_announced.empty? || @launch_announced == "-"
  end

  def clean_launch_status
    @launch_status = nil if @launch_status.nil? || @launch_status.empty? || @launch_status == "-"
  end

  def clean_body_dimensions
    @body_dimensions = nil if @body_dimensions.nil? || @body_dimensions.empty? || @body_dimensions == "-"
  end

  def clean_body_weight
    @body_weight = nil if @body_weight.nil? || @body_weight.empty? || @body_weight == "-"
  end

  def clean_body_sim
    @body_sim = nil if @body_sim.nil? || @body_sim.empty? || @body_sim == "-"
  end

  def clean_display_resolution
    @display_resolution = nil if @display_resolution.nil? || @display_resolution.empty? || @display_resolution == "-"
  end

  def clean_features_sensors
    @features_sensors = nil if @features_sensors.nil? || @features_sensors.empty? || @features_sensors == "-"
  end

  def clean_platform_os
    @platform_os = nil if @platform_os.nil? || @platform_os.empty? || @platform_os == "-"
  end





  
  
  def replace_with_null
  instance_variables.each do |var|
    value = instance_variable_get(var)
    instance_variable_set(var, nil) if value == "" || value == "-"
    end
  end
  def print
     puts "OEM: #{@oem}, Model: #{@model}, Launch Announced: #{@launch_announced}, Launch Status: #{@launch_status}, Body Dimensions: #{@body_dimensions}, Body Weight: #{@body_weight}, Body SIM: #{@body_sim}, Display Type: #{@display_type}, Display Size: #{@display_size}, Display Resolution: #{@display_resolution}, Features Sensors: #{@features_sensors}, Platform OS: #{@platform_os}"
  end

end

#use read_csv function for pulling in data
def read_csv(filename)
  cells = []
  CSV.foreach(filename, headers: true) do |row|
    cell = Cell.new(row)
    cell.replace_with_null #replace all missing or "-" values with null or something similar that can be ignored during calculations
    cells << cell
  end

  cells
end

#pull in our data and use the function
cells = read_csv('cells.csv')
puts "Number of cells read: #{cells.length}" #print so we can verify all data was read in properly should print 1000 cell were read_csv


if print_cells == 1
  cells.each do |cell|
    cell.print
  end
end
