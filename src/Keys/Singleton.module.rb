def keys
  @keys ||= {}
end

def key key, type = nil
  match_key = key.is_a?(Symbol) ? key.to_s : key
  type = if type
           Type.from(type).for(match_key)
           Type.from type
         else
           ValueMustExistFor[match_key]
           ValueMayExistFor[match_key]
         end
  self.keys[key] = type
end

def key key, type = nil
  match_key = key.is_a?(Symbol) ? key.to_s : key
  parser = -> json {
    value = json[match_key]
    fail unless value

    if type
      fail unless type === value
      if [String, Array, Hash].include? type
        fail if value.empty?
      end
    end

    value
  }

  self.keys[key] = parser
end

def optional_key key, type = nil
  match_key = key.is_a?(Symbol) ? key.to_s : key
  parser = -> json {
    value = json[match_key]

    if value
      if type
        fail unless type === value
        if [String, Array, Hash].include? type
          fail if value.empty?
        end
      end
      value
    end
  }

  self.keys[key] = parser
end


def optional &block
  new_class = dup
  new_class.define_singleton_method :key, &method(:optional_key)
  new_class.instance_exec &block
  self.keys.merge! new_class.keys
end

def initialize_copy
  super
  @keys = {}
end

def types
  @types ||= {}
end

def type symbol, &default
  types[symbol] = Type.new &default
  define_singleton_method symbol do |&custom|
    types[symbol].expand &custom
  end
end
