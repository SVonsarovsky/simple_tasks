class Module
  def attribute(attr, &block)
    if attr.is_a? Hash
      #Converts hash to a nested array of [ key, value ] arrays and gets the first item
      attr, default = attr.to_a.first
    else
      default = nil
    end

    attr = attr.to_sym

    define_method attr do
      if instance_variables.include? :"@#{attr}"
        instance_variable_get :"@#{attr}"
      else
        block ? instance_eval(&block) : default
      end
    end

    define_method "#{attr}=" do |v|
      instance_variable_set :"@#{attr}", v
    end

    define_method "#{attr}?" do
      #You can use __send__ if the name send clashes with an existing method in obj.
      #This method is deprecated
      #__send__(attr)
      !!send(attr) # double !! because we need boolean result
    end
  end
end