class RentRoll
  #Load CSV file
  require 'csv'

  #Create rent roll report
  def rent_roll_report(date)
    csv_data = CSV.read('units-and-residents.txt', headers: true)

    #Create empty array to hold report info
    rent_roll_report = []

    #Loop through each row in the CSV
    csv_data.each do |row|
      unit_number = row['unit']
      floor_plan = row['floor_plan']
      resident_name = row['resident']
      move_in_date = row['move_in']
      move_out_date = row['move_out']

      #Create rent roll report data
      #puts Date.parse(move_in_date)
      #puts Date.parse(move_out_date)
      #puts date
      if move_in_date.nil? && move_out_date.nil?
        resident_status = 'Vacant'
      elsif move_in_date.nil? || Date.parse(move_in_date) > date
        resident_status = 'future'
      elsif move_out_date.nil? || Date.parse(move_out_date) >= date
        resident_status = 'current'
      else
        resident_status = 'Vacant'
      end

      #Add report data to rent roll report array
      rent_roll_report << [unit_number, floor_plan, resident_name, resident_status, move_in_date, move_out_date]
    end

    #puts rent_roll_report

    #Format report string
    report_string = ""
    rent_roll_report.sort_by { |row| row[0].to_i}.each do |row|
      report_string << "#{row[0]}\t#{row[1]}\t#{row[2]}\t#{row[3]}\t#{row[4]}\t#{row[5]}\n"
    end

    puts report_string
  end

  #Query key statistics
  def key_statistics(date)
    csv_data = CSV.read('units-and-residents.txt', headers: true)
    vacant_units = 0
    occupied_units = 0
    leased_units = 0
    stats = Hash.new

    #Loop through each row in the CSV
    csv_data.each do |row|
      move_in_date = row['move_in']
      move_out_date = row['move_out']

      #Count vacant units
      if move_in_date.nil? && move_out_date.nil? || !move_out_date.nil? && Date.parse(move_out_date) <= date
        vacant_units += 1
      end

      #Count occupied units
      if !move_in_date.nil? && (move_out_date.nil? || Date.parse(move_in_date) < date && Date.parse(move_out_date) > date)
        occupied_units += 1
      end

     #Count leased units
      if !move_in_date.nil? && (move_out_date.nil? || Date.parse(move_out_date) > date)
        leased_units += 1
      end
    end

    stats["vacant_units"] = vacant_units
    stats["occupied_units"] = occupied_units
    stats["leased_units"] = leased_units

    puts stats
  end

  #Test in console
  #RentRoll.new.rent_roll_report(Date.new(2023/1/1))
  #RentRoll.new.key_statistics(Date.new(2023/1/1))
end
