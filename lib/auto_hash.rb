
require 'bcrypt'

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

          value = BCrypt::Password.create(value)

          # write_attribute() is the documented way to write to a AR
          # field after you've overridden the setter,
          # http://ar.rubyonrails.org/classes/ActiveRecord/Base.html
          write_attribute(field_name, value)

        end

        # Dynamically define the "comparer"
        define_method "#{field_name}" do

          BCrypt::Password.new(read_attribute(field_name))

        end

      end

    end

    #send :include, InstanceMethods

  end

  # module InstanceMethods
  # end

end


ActiveRecord::Base.send :include, AutoHash
