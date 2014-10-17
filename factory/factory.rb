class Factory
  def self.new(*attrs, &block)
    Class.new do

      #+ ::new
      #+ ==
      #+ []
      #+ []=
      #+ each
      #- each_pair
      #+ eql?
      #+ hash
      #+ inspect
      #+ length
      #+ members
      #+ select
      #+ size
      #+ to_a
      #+ to_h
      #+ to_s
      #+ values
      #+ values_at

      #self.send(:attr_accessor, *attrs)
      attr_accessor *attrs

      self.send(:define_method, :initialize) do |*vals|
        if attrs.length < vals.length
          raise ArgumentError.new('Factory size differs')
        end
        attrs.each_with_index {|val, i|
          instance_variable_set(:"@#{val}", i >= vals.length ? nil : vals[i] )
        }
      end

      #self.class_eval(&block) if block
      class_eval(&block) if block

      def select(&block)
        #a = []
        #values.each{|v| a << v if block.call(v)}
        #a
        values.select{|v| block.call(v)}
      end

      def each(&block)
        values.each{|v| block.call(v)}
      end

      def each_pair(&block)
        to_h.each_pair {|k, v| block.call(k, v) }
      end

      def to_s
        "#<factory " +
            self.class.to_s + ' ' +
            instance_variables.map { |value|
              v = instance_variable_get(:"#{value}")
              value.to_s[1..-1] + '=' +
                ((v.nil?) ? 'nil' : '"'+v.to_s+'"')
            }.join(", ") +
            ">"
      end
      alias :inspect :to_s

      def to_a
        instance_variables.map {|value| instance_variable_get(:"#{value}")}
      end
      alias :values :to_a

      def to_h
        Hash[members.zip(values)]
      end
      alias :hash :to_h

      def values_at(*indexes)
        result = []
        for i in indexes
          result << (i >= values.length ? nil : values[i])
        end
        result
      end

      def length
        instance_variables.length
      end

      alias_method :size, :length

      def members
        instance_variables
      end

      def [](member)
        if member.is_a? Fixnum
          instance_variable_get(:"#{instance_variables[member]}")
        else
          instance_variable_get(:"@#{member}")
        end
      end
      #self.send(:define_method, "[]") do |index|
      #end

      def []=(index, value)
        instance_variable_set(:"@#{index}", value)
      end
      #self.send(:define_method, "[]=") do |index, value|
      #  self.instance_variable_set(:"@#{index}", value)
      #end

      #self.send(:define_method, "==") do |other|
      def ==(other)
        return false unless self.class == other.class && self.length == other.length
        instance_variables.each_with_index {|val, i|
          v = instance_variable_get(:"#{val}")
          return false unless v.eql? other[i]
        }
        return true
      end
      alias_method :eql?, :==
    end
  end
end


Customer = Factory.new(:name, :surname, :addr) do
  def greeting
    "Hello #{name} #{surname}!"
  end
end

c1 = Customer.new("Dave", "Brown", "Dnepr")
c2 = Customer.new("Dave", "Brown")
puts (c1 == c2)
c2.addr = "Dnepr"
puts (c1 == c2)
c2.addr = nil
puts c1[0]
puts c1.name
puts c1["name"]
puts c1.values_at 0, 1
puts c1.to_h
puts c1.size
c1["name"] = "123"
c1.surname = "321"
puts c1.to_h
puts c2.to_h
puts c2.select{|v| (v == "Brown" || v.nil? )}
#c1.each {|v| puts v}
#c2.each_pair {|k, v| puts k, v}
#puts [1, 2, nil, 4].select{|v| v==1 or v.nil?}