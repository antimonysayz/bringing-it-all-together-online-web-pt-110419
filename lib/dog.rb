class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    sql = <<-SQL
    INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(hash)
    dog = Dog.new(hash)
    dog.save
  end

  def self.new_from_db(row)
    attributes = {
      :id => row[0],
      :name => row[1],
      :breed => row[2]
    }
    Dog.new(attributes)
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    SQL
    dog = DB[:conn].execute(sql, id)
    self.new_from_db(dog)
    self.id
  end


end
