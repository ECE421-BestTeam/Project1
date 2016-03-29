require 'mysql'

class DatabaseMySql 
  
  # settings is a hash
  def initialize(settings)
    begin
      @db = Mysql.new(settings.host, settings.user, settings.pwd, settings.db, settings.port)
    rescue Mysql::Error => e
      puts e.error
    end
  end
  
  # returns all entries as an array of hashes
  def getAll(table)
    records = []
    begin
      records = @con.query("SELECT * FROM #{table} WHERE id = '#{id}'")
    rescue Mysql::Error => e
      puts e
    end
    return records
  end
  
  # returns entry (hash)
  def get(table, id)
    record = nil
    begin
      record = @con.query("SELECT * FROM #{table} WHERE id = '#{id}'")
    rescue Mysql::Error => e
      puts e
    end
    return record
  end
  
  # adds an entry
  # returns the id
  def add(table, newEntry)

  end
  
  # updates an entry
  # returns id
  def update(table, updatedEntry)

  end
  
  # deletes an entry by id
  # returns true on success
  def delete(table, id)

  end
  
end
