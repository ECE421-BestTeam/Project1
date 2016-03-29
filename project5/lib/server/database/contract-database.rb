module DatabaseContract
  
  def class_invariant

  end
  
  def pre_initialize(type, settings)
    # type should be a symbol, :local or :mysql
    assert type.class == Symbol, "type must be initalized as a Symbol"
    # settings should be a hash with contents dependant on the type
    assert settings.class == Hash, "settings must be of type Hash"
    # :local - nothing required
    if type == :mysql
      assert setting.has_key?(:host) && setting(:host).class == String, "host must be of type String"
      assert setting.has_key?(:password) && setting(:password).class == String, "password must be of type String"
      assert setting.has_key?(:db) && setting(:db).class == Mysql, "db must be of type Mysql"
      assert setting.has_key?(:port) && setting(:port).class == Fixnum, "port must be of type Fixnum"
    end
    # :mysql - host, username, password, db, port  (all string, except port => fixnum)
  end

  def post_initialize
    
  end
  
  def pre_lockTable(table, wait, &checkOutFn)
    assert table.class == String, "table must be a String"
    assert wait.class == Float, "wait must be a Float"
  end
  
  def post_lockTable
  
  end
  
  def pre_lockEntry(table, id, wait, &checkOutFn)
    assert table.class == String, "table must be a String"
    assert id.class == String, "id must be a String"
    assert wait.class == Float, "wait must be a Float"
  end
  
  def post_lockEntry
  
  end
  
  def pre_getAll(table)
    assert table.class == String, "table must be a String"
    
  end
  
  def post_getAll(result)
    assert result.class == Hash, "result must be a Hash"
  end
  
  def pre_get(table, id)
   assert table.class == String, "table must be a String"
   assert id.class == String "id must be a String"
  end
  
  def post_get(result)
    assert result.class == Hash, "result must be a Hash"
  end
  
  def pre_add(table, entry)
    assert table.class == String, "table must be a String"
    assert entry.class == String "entry must be a String"
    
  end
  
  def post_add(result)
    assert result.class == String, "result must be a an id of type String"
  end
  
  def pre_update(table, id, entry)
    assert table.class == String, "table must be a String"
    assert entry.class == String "entry must be a String"
    assert id.class == String "id must be a String"
  end
    
  def post_update(result)
    assert result.class == String, "result must be a String"
  end
  
  def pre_delete(table, id)
    assert table.class == String, "table must be a String"
    assert id.class == String "id must be a String"
  end
  
  def post_delete(result)
    assert result == True || result == False, "result must either be True or False"
  end
  
end