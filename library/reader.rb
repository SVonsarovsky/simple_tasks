class Reader

  attr_accessor :name, :email, :city, :street, :house

  def initialize(name, email='', city='', street='', house='')
    @name = name
    @email = email
    @city = city
    @street = street
    @house = house
  end
  def ==(other_reader)
    unless other_reader.instance_of?(Reader)
      raise 'Incorrect type of @other_reader param'
    end
    return (@name == other_reader.name && @email == other_reader.email)
  end
  def reader_key
    return @name +'::'+@email
  end
  def to_s
    @name + ((@email != '') ? ' <'+ @email +'>': '')
  end
  def to_str
    to_s
  end
end
