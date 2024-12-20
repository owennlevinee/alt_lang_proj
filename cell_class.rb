#this file defines the cell class

class Cell
    attr_accessor :oem, :model, :launch_announced, :launch_status, :body_dimensions, :body_weight, :body_sim,
                  :display_type, :display_size, :display_resolution, :features_sensors, :platform_os
  
    def initialize(data) #map our data to columns in the csv
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
  
    def clean_data #run our data through its various cleaning methods
      clean_launch_announced #done
      clean_launch_status #done
      clean_body_dimensions #done
      clean_body_weight #done
      clean_body_sim #done
      clean_display_type #done
      clean_display_size #done
      clean_display_resolution #done
      clean_features_sensors #done
      clean_platform_os #done
    end
  
    def clean_launch_announced #method done
      @launch_announced = @launch_announced.scan(/\d{4}/).first if @launch_announced =~ /\d{4}/ #use regex to pull the year
      @launch_announced = @launch_announced.to_i
      if @launch_announced.nil? || @launch_announced == 0 #if empty set it to null
        @launch_announced = nil
      end
    end
  
    def clean_launch_status #method done
      if @launch_status =~ /\d{4}/ #use regex to pull the year again
        @launch_status = @launch_status.scan(/\d{4}/).first
      elsif @launch_status == 'Discontinued' || @launch_status == 'Cancelled' #or find if it was disco or cance
        @launch_status = @launch_status
      else
        @launch_status = nil
      end
    end
  
    def clean_body_dimensions #method done
      if @body_dimensions.nil? || @body_dimensions.empty? || @body_dimensions == '-' || @body_dimensions == ''
        @body_dimensions = nil
      end
    end
  
    def clean_body_weight #method done
      if @body_weight =~ /\d+\s*g/
          @body_weight = @body_weight[/\d+\s*g/].to_f #using regex for the millionth time
      else
        @body_weight = nil
      end
      if @body_weight == 0
        @body_weight = nil
      end
    end
  
    def clean_body_sim #method done
      if @body_sim =~ /\A(?:No|Yes)\z/ #omg more regex
        @body_sim = nil
      end
    end
  
    def clean_display_type #method done
      if @display_type.nil? || @display_type.empty? || @display_type == '-' || @display_type == ''
        @display_type = nil
      end
    end
  
    def clean_display_size #method done
      if @display_size =~ /\d+(\.\d+)?\s*inches?/ #MORE REGEX
        @display_size = @display_size[/\d+(\.\d+)?/].to_f
      else
        @display_size = nil
        @display_size = @display_size.to_f
      end
    end
  
    def clean_display_resolution #method done
      if @display_resolution.nil? || @display_resolution.empty? || @display_resolution == '-' || @display_resolution == ''
        @display_resolution = nil
      end
    end
  
    def clean_features_sensors #method done
      if @features_sensors =~ /\A\d+\z/ #ALL OF THE REGEXXXX
        @features_sensors = nil
      end
    end
  
    def clean_platform_os #method done
      if @platform_os.nil? || @platform_os.empty? || @platform_os == '-' || @platform_os == ''
        @platform_os = nil
      end
    end
  
    def replace_with_null
      instance_variables.each do |var|
        value = instance_variable_get(var)
        instance_variable_set(var, nil) if ['', '-'].include?(value)
      end
    end
  
    #7 creative methods
  
    def is_5g_capable #method done 1
        if @model.downcase.include?('5g') #does the model include 5g? if so print that its 5g capable and otherwise print it isn't
          puts "#{@model} is 5g capable."
        else
          puts "#{@model} is not 5g capable."
        end
    end
  
  
    def calc_phone_volume #method done 2 
      if @body_dimensions.nil?
        puts "Error unable to determine dimensions for #{@model}"
        return nil
      end
  
      #extracting dimensions in inches from string using regex
      dimensions_in_inches = @body_dimensions.match(/(\d+\.?\d*) x (\d+\.?\d*) x (\d+\.?\d*) in/) 
  
      if dimensions_in_inches.nil? || dimensions_in_inches.length < 4 #some exception handling if the dimensions don't work right
        puts "Error unable to determine dimensions for #{@model}"
        return nil
      end
  
      length_in = dimensions_in_inches[1].to_f
      width_in = dimensions_in_inches[2].to_f
      height_in = dimensions_in_inches[3].to_f #calculate the volume
  
      volume_cubic_inches = length_in * width_in * height_in
      puts "#{@model} has a volume of #{volume_cubic_inches.round(2)}" 
      return nil
    end
  
    def is_launched #method done 3
      if @launch_status.nil? 
        puts "Error unable to determine launch status of #{@model}"
      elsif @launch_status == 'Discontinued'
        puts "#{@model} was discontinued"
      elsif @launch_status == 'Cancelled'
        puts "#{@model} was cancelled"
      else
        puts "#{@model} is currently out and has been since #{@launch_status}"
      end
    end
  
  
    def features_sensors_count #method done 4
        if @features_sensors == "V1" || @features_sensors.nil?
          result = "Error: Unable to find sensor count for #{@model}"
          puts result
        else
          # Split the features_sensors string by comma and count the number of elements
          sensors = @features_sensors.split(',').map(&:strip)
          result = "#{@model} has #{sensors.count} feature sensors"
          puts result
          return sensors.count
        end
      end
  
    def print #method done 5 
      puts "OEM: #{@oem}, Model: #{@model}, Launch Announced: #{@launch_announced}, Launch Status: #{@launch_status}, Body Dimensions: #{@body_dimensions}, Body Weight: #{@body_weight}, Body SIM: #{@body_sim}, Display Type: #{@display_type}, Display Size: #{@display_size}, Display Resolution: #{@display_resolution}, Features Sensors: #{@features_sensors}, Platform OS: #{@platform_os}"
    end #just prints everything about the row
  
    def get_ppi #method done 6
      if @display_resolution.nil? #check for the case where there is no resolution info given
        puts "Error: Unable to calculate pixel density for #{@model}."
        return
      end
  
      #extract PPI from the display_resolution column strings
      ppi_match = @display_resolution.match(/~(\d+)\s*ppi/i)
  
      if ppi_match #some more checking that the regex captured a proper string of numbers for a ppi value
        pixel_density = ppi_match[1].to_i
        puts "#{@model} has a pixel density of #{pixel_density} pixels per inch."
      else
        puts "Error: Unable to extract pixel density for #{@model}."
      end
    end
  
    def self.find_by_model(model_text, cells) #method done 7
        if model_text.strip.empty? #if user input is empty
            puts "Please enter a valid model name."
            return
          end
      matching_cells = cells.select { |cell| cell.model.downcase.include?(model_text.downcase) }
        
      if matching_cells.any?
        matching_cells.each do |cell|
          cell.print #print all cells where the inputted string is in the model
        end
      else
        puts "No phones found with model including '#{model_text}'." #otherwise print there are none
      end
    end
  
  end