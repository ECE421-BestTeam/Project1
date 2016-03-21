require 'json'

class DatabaseLocal
  
  def initialize
    
  end
  
  # returns all entries as an array of hashes
  def getAll(table)
    file = nil
    begin
      file = File.read("../data/#{table}.json")
    rescue Errno::ENOENT => e
      file = JSON.generate([])
    end
      
    return JSON.parse(file)
  end
  
  # returns entry (hash)
  def get(table, id)
    entries = getAll(table)
    entries.each do |entry|
      if entry[:id] == id
        return entry
      end
    end
    return nil
  end
  
  # adds an entry
  # returns the id
  def add(table, newEntry)
    entries = getAll(table)
    maxId = 0
    entries.each do |entry|
      if entry[:id] > maxId
        maxId = entry[:id]
      end
    end
    maxId += 1
    newEntry[:id] = maxId
    entries.push(newEntry)
    File.write("../data/#{table}.json", JSON.generate(entries))
    return maxId
  end
  
  # updates an entry
  # returns id
  def update(table, updatedEntry)
    entries = getAll(table)
    raise ArgumentError, "No id in entry" if !updatedUntry[:id]
    index = nil
    entries.each_with_index do |entry, ind|
      if entry[:id] == updatedUntry[:id]
        index = ind
      end
    end
    raise ArgumentError, "invalid id in entry" if !index
    entries[index] = updatedEntry
    File.write("../data/#{table}.json", JSON.generate(entries))
    return updatedEntry[:id]
  end
  
  # deletes an entry by id
  # returns true on success
  def delete(table, id)
    entries = getAll(table)
    index = nil
    entries.each_with_index do |entry, ind|
      if entry[:id] == id
        index = ind
      end
    end
    raise ArgumentError, "requested record does not exist" if !index
    entries.delete_at index
    File.write("../data/#{table}.json", JSON.generate(entries))
    return true
  end
  
end