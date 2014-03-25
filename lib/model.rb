require 'mysql2'

module ORM
  module Validatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    def valid?
      validate!
      errors.empty?
    end

    private
    def validate!
      validators.each_key do |field|
        validators[field].each do |validator|
          if msg = validator.call(send(field))
            @errors[field] << msg
          end
        end
      end
    end

    def validators
      self.class.validators
    end

    module ClassMethods
      def validators
        @v
      end

      def validates(field, fn)
        @v ||= Hash.new { |k, v| k[v] = [] }
        @v[field] << fn
      end
    end
  end

  class Model
    include Validatable

    @@db = Mysql2::Client.new(host: 'localhost', username: 'testos', password: 'secretos', database: 'vorm')

    attr_accessor :id, :errors

    # Set each attributes value.
    def initialize(params={})
      @errors = Hash.new { |k, v| k[v] = [] }
      params.each do |attr, value|
        self.send("#{attr}=", value)
      end if params
      super()
    end

    # def valid?
    #   validate
    #   errors.empty?
    # end

    # make this private?
    # def validate
    #   fields = self.class.fields
    #   validators = self.class.validators
    #   fields.each do |field|
    #     validators[field].each do |validator|
    #       val = send(field)
    #       p val
    #       ret = validator.call(val)
    #       p ret
    #     end if validators[field]
    #   end
    # end

    # def save
    #   keyvals = []
    #   for field in self.class.fields
    #     val = send(field) || 'NULL'
    #     keyvals << "#{field}=#{val}"
    #     #keyvals << "#{field}='#{self.field}'"
    #   end
    #   p keyvals.join(', ')
    #   #p keyvals.join(', ')
    #   # sql = "INSERT INTO #{table} SET #{attr}='#'"
    #   # @@
    # end

    class << self
      def table(name=nil)
        @table ||= name
      end

      # def validators
      #   @validators
      # end

      def fields(*args)
        args.each do |field|
          attr_accessor(field)
        end
        @fields ||= args
      end

      # def validates(field, &block)
      #   @validators ||= {}
      #   @validators[field] = [] if @validators[field].nil?
      #   @validators[field] << block
      # end

      # Fetch all the records from @table.
      # @return [Array] array of subclass instances.
      def all
        sql = "SELECT * FROM #{table}"
        res = @@db.query(sql)
        res.map(&method(:new))
      end
    end

  end
end
