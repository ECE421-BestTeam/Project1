module DatabaseContract
  
  def class_invariant

  end
  
  def pre_initialize(type, settings)
    # type should be a symbol, :local or :mysql
    # settings should be a hash with contents dependant on the type
    # :local - nothing required
    # :mysql - host, username, password, db, port  (all string, except port => fixnum)
  end

  def post_initialize
    
  end
  
  def pre_lockTable(table, wait, &checkOutFn)
  
  end
  
  def post_lockTable
  
  end
  
  def pre_lockEntry(table, id, wait, &checkOutFn)
  
  end
  
  def post_lockEntry
  
  end
  
  def pre_getAll(table)
    
  end
  
  def post_getAll(rsult)
    
  end
  
  def pre_get(table, id)
    
  end
  
  def post_get(result)
    
  end
  
  def pre_add(table, entry)
    
  end
  
  def post_add(result)
    
  end
  
  def pre_update(table, id, entry)
    
  end
    
  def post_update(result)

  end
  
  def pre_delete(table, id)
    
  end
  
  def post_delete(result)

  end
  
end