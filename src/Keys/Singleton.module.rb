def keys
  @keys ||= {}
end

def key key, type = nil
  parser = if type
             Both ValueMustExistFor[key], TypeOfValueMustBe[type]
           else
             ValueMustExistFor[key]
           end

  self.keys[key] = parser
end

def optional_key key, type = nil
  parser = if type
             Both ValueMayExistFor[key], TypeOfValueMustBe[type]
           else
             ValueMayExistFor[key]
           end

  self.keys[key] = parser
end


def Both key_parser, value_parser
  -> json {
    if value = key_parser[json]
      value_parser[value]
    end
  }
end


ValueMustExistFor = KeyParser.new do |json, key|
  value = json[key]
  fail unless value
  value
end

ValueMayExistFor = KeyParser.new do |json, key|
  json[key]
end

TypeOfValueMustBe = ValueParser.new do |value, type|
  fail unless type === value
  if [String, Array, Hash].include? type
    fail if value.empty?
  end
  value
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
