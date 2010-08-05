
module AutoHash

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    # This is the macro style class method called from the AR model
    def auto_hash(*args)

      # Create a setter and "comparer" for each arg
      args.each do |field_name|

        # Dynamically define a new setter
        define_method "#{field_name}=" do |value|

          value = AutoHashBuilder.auto_hash_create(value)

          # write_attribute() is the documented way to write to a AR
          # field after you've overridden the setter,
          # http://ar.rubyonrails.org/classes/ActiveRecord/Base.html
          write_attribute(field_name, value)

        end

        # Dynamically define the "comparer"
        define_method "#{field_name}_hash_match?".to_sym do |match|
          existing = send(field_name)
          value = AutoHashBuilder.auto_hash_compare(existing, match.to_s)
        end

      end

    end

    # This nested class is here only to avoid exposing the autohash
    # inner api to the AR model. It has no other excuse to be a class.
    class AutoHashBuilder

      class << self

        def auto_hash_create(value)
          salt = ActiveSupport::SecureRandom.hex(10)
          hash = create_hash(value, salt)
          "#{hash}-#{salt}"
        end

        def auto_hash_compare(hash, value)
          salt = extract_salt_part(hash)
          hash_old = extract_hash_part(hash)
          hash_new = create_hash(value, salt) # try to recreate same hash
          hash_new == hash_old
        end

        private #~*~*~*~*~*~*~*~*~*~*

        def create_hash(value, salt)
          Digest::SHA2.new.update(value + salt).to_s
        end

        def extract_hash_part(hash)
          hash.split(/-/)[0]
        end

        def extract_salt_part(hash)
          hash.split(/-/)[1]
        end

      end # << class << self

    end

    #send :include, InstanceMethods

  end

  # module InstanceMethods
  # end

end


ActiveRecord::Base.send :include, AutoHash
