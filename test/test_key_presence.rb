require_relative 'helper'

app do
  key :first
  key :second
end

it 'does this' do
  p 'does thiis'
end

it 'does that' do
  is :subj, :pred
end
