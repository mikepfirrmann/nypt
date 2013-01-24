module TruncateExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def truncate
      connection.execute("TRUNCATE #{table_name};")
    end
  end
end

ActiveRecord::Base.send(:include, TruncateExtension)
