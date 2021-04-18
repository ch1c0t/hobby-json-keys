require 'hobby/json'

def self.included app
  app.include JSON
  app.extend Singleton
end

def keys
  @keys ||= begin
              self.class.key_parsers.map { |parser| parser[json] }.to_h
            rescue => e
              p e
              response.status = 400
              halt
            end
end
