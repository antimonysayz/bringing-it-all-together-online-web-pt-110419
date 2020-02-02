class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dog
    SQL
    DB[:conn].execute(sql)
  end

end
