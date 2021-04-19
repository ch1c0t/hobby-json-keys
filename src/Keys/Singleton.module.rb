def key_parsers
  @key_parsers ||= []
end

def key key, type = nil
  key = key.to_s if key.is_a? Symbol
  parser = -> json {
    value = json[key]
    fail unless value

    if type
      fail unless type === value
      if [String, Array, Hash].include? type
        fail if value.empty?
      end
    end

    [key, value]
  }

  self.key_parsers << parser
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
