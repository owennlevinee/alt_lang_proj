require 'minitest/autorun'
require_relative 'helpers' # Replace with the actual name of your script file




#If your programming language has unit testing capability such as junit or pyunit, use that for your unit tests. 
#If not, write your own unit tests for each method. 
#On top of a unit test for each method, there are three tests you are required to have:

#1. Ensure the file being read is not empty.
#2. Ensure each column's final transformation matches what is stated above as its final form (ex: test if display_size is now a float)
#3. Ensure all missing or "-" data is replaced with a null value.


class CellTest < Minitest::Test
  # Create a setup method to prepare test data
  def setup
    @cells = read_csv('cells.csv')
  end


  #ensure that the file being read is not empty testing requirement 1
  def test_read_file_not_empty
    refute_empty @cells, 'File is empty'
  end


  #this method tests each cell of each row to make sure it either valid data or null which fulfills both testing requirement 2 and 3
  def test_all_attributes
    @cells.each do |cell|
      #test oem attribute
      assert_instance_of String, cell.oem, "#{cell.model}'s OEM should be a String or nil" unless cell.oem.nil?
  
      #test model attr
      assert_instance_of String, cell.model, "#{cell.oem}'s model should be a String or nil" unless cell.model.nil?
  
      #test launch_announced attr
      assert_instance_of Integer, cell.launch_announced, "#{cell.model}'s launch announced year should be an Integer or nil" unless cell.launch_announced.nil?
      assert_operator cell.launch_announced, :>, 999, "#{cell.model}'s launch announced year should be a 4-digit Integer" unless cell.launch_announced.nil?
      assert_operator cell.launch_announced, :<, 10000, "#{cell.model}'s launch announced year should be a 4-digit Integer" unless cell.launch_announced.nil?
  
      #test launch_status attr
      assert_instance_of String, cell.launch_status, "#{cell.model}'s launch status should be a String or nil" unless cell.launch_status.nil?
  
      #test body_dimensions attr
      assert_instance_of String, cell.body_dimensions, "#{cell.model}'s body dimensions should be a String or nil" unless cell.body_dimensions.nil?
  
      #test body_weight attr
      assert_instance_of Float, cell.body_weight, "#{cell.model}'s body weight should be a Float or nil" unless cell.body_weight.nil?
  
      #test body_sim attr
      assert_instance_of String, cell.body_sim, "#{cell.model}'s body SIM should be a String or nil" unless cell.body_sim.nil?
      refute_includes(["No", "Yes"], cell.body_sim, "#{cell.model}'s body SIM should not be 'No' or 'Yes'") unless cell.body_sim.nil?
  
      #test display_type attr
      assert_instance_of String, cell.display_type, "#{cell.model}'s display type should be a String or nil" unless cell.display_type.nil?
  
      #test display_size attr
      assert_instance_of Float, cell.display_size, "#{cell.model}'s display size should be a Float or nil" unless cell.display_size.nil?
  
      #test display_resolution attr
      assert_instance_of String, cell.display_resolution, "#{cell.model}'s display resolution should be a String or nil" unless cell.display_resolution.nil?
  
      #test feature_sensors attr
      assert_instance_of String, cell.features_sensors, "#{cell.model}'s features sensors should be a String or nil" unless cell.features_sensors.nil?
  
      #test platform_os attr
      assert_instance_of String, cell.platform_os, "#{cell.model}'s platform OS should be a String or nil" unless cell.platform_os.nil?
    end
  end
  #here are the tests for each of our custom methods
  def test_is_5g_capable
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.is_5g_capable }
    end
  end
  
  def test_calc_phone_volume
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.calc_phone_volume }
    end
  end
  
  def test_is_launched
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.is_launched }
    end
  end
  
  def test_features_sensors_count
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.features_sensors_count }
    end
  end
  
  def test_print
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.print }
    end
  end
  
  def test_get_ppi
    @cells.each do |cell|
      assert_output(/.*\n/) { cell.get_ppi }
    end
  end
end
