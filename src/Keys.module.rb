require 'hobby/json'

def self.included app
  app.include JSON
  app.extend Singleton

  %i[
    String
    Array
    Hash
  ].each do |symbol|
    app.type symbol do
      is_a Object.const_get symbol
      is_not_empty
    end
  end
end

def keys
  @keys ||= begin
              self.class.keys
                .transform_values { |parser| parser[json] }
                .compact
            rescue
              response.status = 400
              halt
            end
end
