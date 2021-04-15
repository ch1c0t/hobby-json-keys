Gem::Specification.new do |g|
  g.name    = 'hobby-json-keys'
  g.files   = `git ls-files`.split($/)
  g.version = '0.0.0'
  g.summary = 'A Hobby extension to parse JSON requests.'
  g.author  = 'Anatoly Chernov'
  g.email   = 'chertoly@gmail.com'

  g.add_dependency 'hobby-json', '~> 0.0.6'
end
