module Hobby
  module JSON
    module Keys
      def self.included app
        app.extend Singleton
      end

      module Singleton
        def key key
          p key
        end
      end
    end
  end
end
