# pull in neccesary libraries
require_relative 'helpers.rb'

# pull in our data and use the function
cells = read_csv('cells.csv')
puts "Number of cells read: #{cells.length}" # print so we can verify all data was read in properly should print 1000 cell were read_csv

#quick demo of all of our methods

#lets use the first row specific methods on the first 6 rows
cells.first(6).each do |cell|
  cell.is_5g_capable 
  cell.calc_phone_volume 
  cell.is_launched
  cell.features_sensors_count 
  cell.get_ppi
  cell.print
end

#then lets show the find_by_model method which needs the whole object array
user_search_text = get_user_input("Enter a model of phone you want the specs of")
Cell.find_by_model(user_search_text, cells)






#1. What company (oem) has the highest average weight of the phone body? done
#2. Was there any phones that were announced in one year and released in another? What are they? Give me the oem and models. done
#3. How many phones have only one feature sensor? done
#4. What year had the most phones launched in any year later than 1999? 

def find_highest_average_weight(cells)
  #create hashes to store both count and weight for each oem
  company_weights = Hash.new { |hash, key| hash[key] = { total_weight: 0, phone_count: 0 } }

  #calculate weight and count ttls for ea company
  cells.each do |cell|
    next if cell.body_weight.nil? #skip if body weight is nil
    company_weights[cell.oem][:total_weight] += cell.body_weight
    company_weights[cell.oem][:phone_count] += 1
  end

  #calc avg weight for each oem by dividing the total weight by the count
  company_averages = {}
  company_weights.each do |company, data|
    next if data[:phone_count] == 0 #skip if company has no phones
    company_averages[company] = data[:total_weight] / data[:phone_count]
  end

  #find highest avg of company list
  highest_average_company = company_averages.max_by { |_, avg_weight| avg_weight }
  #return its hash of oem and weight
  return highest_average_company
end

def check_released_announced(cells)
  mismatches = [] #init mismathces array
  cells.each do |cell| #loop through every cell
    if cell.launch_status != 'Discontinued' && cell.launch_status != 'Cancelled' && !cell.launch_status.nil? && !cell.launch_announced.nil?
      if cell.launch_status.strip.to_i != cell.launch_announced #if the data meets all the requirements
        #puts "adding #{cell} to mismatches"
        mismatches.push(cell) #add to mismatches
      end
    end
  end
  
  puts "Mismatches:"
  
  mismatches.each do |mis|
    puts "OEM: #{mis.oem}, Model: #{mis.model}"
  end
end

def only_1_feature(cells) 
  only_1 = [] #init array
  cells.each do |cell| #loop through every cell
    if cell.features_sensors_count == 1 #if it has 1 feature sensor
      only_1.push(cell) #add to array
    end
  end
  puts "There are #{only_1.count} phones with only 1 feature sensor." #print array count
end

#find year with most phones launched after 1999
def year_with_most_phones_launched(cells)
  phones_after_1999 = cells.select{|cell| !cell.launch_announced.nil? && cell.launch_announced > 1999 } #select phones launched after 1999
  phones_by_year = phones_after_1999.group_by{|cell| cell.launch_announced } #group phones by launch year
  year_with_most = phones_by_year.max_by{|_year, phones| phones.count } #find year with most phones
  puts "year with most phones launched after 1999: #{year_with_most[0]} (phones: #{year_with_most[1].count})"#output year
end




highest_average_company = find_highest_average_weight(cells)
if highest_average_company
  puts "The company with the highest average weight of phone body is: #{highest_average_company[0]}, with an average weight of: #{highest_average_company[1]}"
else
  puts "No phones have body weight data."
end

check_released_announced(cells)
  
only_1_feature(cells)

year_with_most_phones_launched(cells)