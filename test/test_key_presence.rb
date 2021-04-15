require_relative 'helper'

app do
  key :first
  key :second
end

describe :Some do
  it 'works' do
    p :asdsd
  end

  it 'works2' do
    is :something, :works
  end
end
