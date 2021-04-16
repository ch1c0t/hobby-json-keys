require 'hobby/json'

module Hobby
  module JSON
    module Keys
      def self.included app
        app.include JSON
        app.extend Singleton
      end

      module Singleton
        def key_parsers
          @key_parsers ||= []
        end

        def key key
          key = key.to_s if key.is_a? Symbol
          parser = -> json {
            [key, (json[key] or fail)]
          }
          self.key_parsers << parser
        end
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
    end
  end
end
