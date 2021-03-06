require_relative("../db/sql_runner")

class Student

  attr_accessor :first_name, :last_name, :house, :age
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @house = options['house']
    @age = options['age']
  end

  def save
    sql = "INSERT INTO students (first_name, last_name, house, age)
           VALUES ($1, $2, $3, $4)
           RETURNING *"
    values = [@first_name, @last_name, @house, @age]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM students"
    SqlRunner.run(sql)
  end

  # finds all students

  def self.all
    sql = "SELECT * FROM students"
    results = SqlRunner.run(sql)
    return results.map {|student| Student.new(student)}
  end

  # finds student by id

  def self.find_by_id(id)
    sql = "SELECT * FROM students
           WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return nil if result == nil
    return Student.new(result)
  end

  def full_name
    return "#{@first_name} #{@last_name}"
  end


end
