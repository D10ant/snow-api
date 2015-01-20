#Add method to the String class to retrieve a string between two markers.
class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

#Import YAML file that describes hash indexes
def YamlImport(yaml_file)
  parsed = begin
    YAML.load(File.open(yaml_file))
  rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
  end
end

#Convert string in to hash using
def hashDescription(record, yaml)
  descHash = Hash.new
  for i in 0..yaml.count - 2
    if check_exists(record[:description], yaml[i]) && check_exists(record[:description], yaml[i+1])
      descHash[yaml[i]] = record[:description].string_between_markers(yaml[i], yaml[i+1])
    else
      descHash[yaml[i]] = record[:description].string_between_markers(yaml[i], yaml[i+2])
    end
  end
  descHash
end

#check if substring exists in string
def check_exists(check,exists)
  if check.include? exists
    return true
  else
    return false
  end
end
