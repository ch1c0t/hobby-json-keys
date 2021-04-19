def initialize &block
  @gates = {}
  instance_exec &block
end

attr_reader :gates

def expand &block
  new_type = dup
  new_type.instance_exec &block
  new_type
end

def initialize_copy original
  super
  @gates = original.gates.dup
end

def is_a type
  @gates[__callee__] = -> it {
    it.is_a? type
  }
end

def is_not_empty
  @gates[__callee__] = -> it {
    not it.empty?
  }
end

def may_be_empty
  @gates.delete :is_not_empty
end

def size value
  @gates[__callee__] = -> it {
    value === it.size
  }
end

def === it
  @gates.values.each do |gate|
    fail unless gate === it
  end
end
