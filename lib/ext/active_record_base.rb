module TruncateExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create(hash)
      if instance = where(hash).first
        return instance
      end

      instance = new
      hash.each {|k,v| instance.send("#{k}=", v)}
      instance.save ? instance : nil
    end

    def find_or_create!(hash)
      instance = find_or_create(hash)
      if instance.nil?
        raise "Could not find or create #{name} from hash: #{hash.inspect}"
      end
      instance
    end

    def truncate
      connection.execute("TRUNCATE #{table_name};")
    end
  end
end

ActiveRecord::Base.send(:include, TruncateExtension)
