def initialize &block
  @block = -> json, key {
    key = key.to_s if key.is_a? Symbol
    block.call json, key
  }
end

def [] key
  -> json {
    @block.call json, key
  }
end
