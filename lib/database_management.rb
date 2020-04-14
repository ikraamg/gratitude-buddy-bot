module DatabaseManagement
  DATA_FOLDER = './db/'.freeze

  def append_to_file(file_name, entry)
    f = File.new("#{DATA_FOLDER}#{file_name}.txt", 'a')
    f.write("#{entry}\n")
    f.close
    'appended'
  end

  def file_exists?(file_name)
    File.file?("#{DATA_FOLDER}#{file_name}.txt")
  end

  def file_to_array(file_name)
    return unless file_exists?(file_name)

    File.read("#{DATA_FOLDER}#{file_name}.txt").split("\n")
  end

  def overwrite_file(file_name, new_array)
    f = File.new("#{DATA_FOLDER}#{file_name}.txt", 'w')
    new_array.each do |item|
      f.write("#{item}\n")
    end
    f.close
    'overwritten'
  end

  def contained_in_file?(file_name, entry)
    return unless file_exists?(file_name)

    file_to_array(file_name).include?(entry.to_s) ? true : false
  end

  def remove_from_file(file_name, entry)
    if contained_in_file?(file_name, entry)
      temp_arr = file_to_array(file_name)
      temp_arr.delete(entry.to_s)
      overwrite_file(file_name, temp_arr)
      'removed'
    else
      'not found'
    end
  end
end

## Tests
# include DatabaseManagement

# append_to_file('fishy', 51_103_543)
# file_to_array('fishy')
# overwrite_file('fishy', %w[this actually works])
# puts contained_in_file?('fishy', 'thos') # false
# puts contained_in_file?('fishy', 'this') # true
# puts remove_from_file('fishy', 'this')
# puts file_exists?('fishy')
