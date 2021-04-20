def initialize &block
  @block = block
end

def [] type
  -> value {
    @block.call value, type
  }
end
