Gem::Specification.new do |g|
  g.name          = 'hobby-json-keys'
  g.files         = ['lib/hobby/json/keys.rb']
  g.version       = '0.0.0'
  g.summary       = 'A Hobby extension to parse JSON requests.'
  g.author        = 'Anatoly Chernov'
  g.email         = 'chertoly@gmail.com'
  g.license       = 'ISC'
  g.homepage      = 'https://github.com/ch1c0t/hobby-json-keys'

  g.add_dependency 'hobby-json', '~> 0.0.6'
end
