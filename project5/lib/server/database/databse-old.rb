require_relative './contract-database'
require_relative './database-local'

class Database
  include DatabaseContract
  
  def initialize(type = :databaseLocal, settings = {})
    pre_initialize(type, settings)
    case type
      when :databaseLocal
        @implementation = DatabaseLocal.new settings
    end
    post_initialize
    class_invariant
  end
  
  # locks a table for the duration of checkOutFn
  # blocks until we get the lock
  def lockTable(table, wait = true, &checkOutFn)
    
    pre_lockTable(table, wait, &checkOutFn)
    
    checkOutFn.call(getAll(table))  # TODO remove and do real implementation
#    @implementation.checkOut(table, id, wait, &checkOutFn)

    post_lockTable
    class_invariant
  end
  
  # locks an entry for the duration of checkOutFn
  # blocks until we get the lock
  def lockEntry(table, id, &checkOutFn)
    
    pre_lockEntry(table, id, &checkOutFn)
    
    checkOutFn.call(get(table, id))  # TODO remove and do real implementation
#    @implementation.checkOut(table, id, wait, &checkOutFn)

    post_lockEntry
    class_invariant
  end
  
  # returns all entries as an array of hashes
  def getAll(table)
    pre_getAll(table)
    
    result = @implementation.getAll(table)
    
    post_getAll(result)
    class_invariant
    return result
  end
  
  # returns entry (hash)
  def get(table, id)
    pre_get(table, id)
    
    result = @implementation.get(table, id)
    
    post_get(result)
    class_invariant
    return result
  end
  
  # adds an entry
  # returns the id
  def add(table, newEntry)
    pre_add(table, newEntry)
    
    result = @implementation.add(table, newEntry)
    
    post_add(result)
    class_invariant
    return result
  end
  
  # updates an entry
  # returns id
  def update(table, updatedEntry)
    pre_update(table, updatedEntry)
    
    result = @implementation.update(table, updatedEntry)
    
    post_update(result)
    class_invariant
    return result
  end
  
  # deletes an entry by id
  # returns true on success
  def delete(table, id)
    pre_delete(table, id)
    
    result = @implementation.delete(table, id)
    
    post_delete(result)
    class_invariant
    return result
  end
  
end

puts Database.new(:databaseLocal).getAll(:checkedOutGames)