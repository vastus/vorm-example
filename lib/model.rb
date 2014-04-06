require 'yaml'
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
          if msg = validator.call(self)
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

  class Config
    @@db = YAML.load_file(File.expand_path('../../config/database.yml', __FILE__))

    class << self
      def db(key)
        @@db[ENV['RACK_ENV']][key.to_s]
      end
    end
  end

  class Model
    include Validatable

    @@db = Mysql2::Client.new(host: 'localhost', username: 'testos', password: 'secretos', database: Config.db(:database))

    attr_accessor :id, :errors

    # Set each attributes value.
    def initialize(params={})
      @errors = Hash.new { |k, v| k[v] = [] }
      params.each do |attr, value|
        self.send("#{attr}=", value)
      end if params
      super()
    end

    def table
      self.class.table
    end

    def fields
      self.class.fields
    end

    def save
      return false if !valid?
      k = fields
      v = k.collect { |k| send(k).nil? ? 'NULL' : send(k) }
      sql = <<-SQL
        INSERT INTO #{table}
        (#{k.join(', ')})
        VALUES ('#{v.join("', '")}')
      SQL
      @@db.query(sql) # returns nil
      self.class.find(last_id)
    end

    def update_with(id, k, v)
      v = v.map { |v| @@db.escape(v) }
      s = k.zip(v).map { |s| "#{s[0]}='#{s[1]}'" }.join(', ')
      sql = <<-SQL
        UPDATE #{table}
        SET #{s}
        WHERE id=#{self.id}
      SQL
      @@db.query(sql)
      self.class.find(id)
    end

    private
    def last_id
      sql = "SELECT LAST_INSERT_ID()"
      res = @@db.query(sql)
      res.first['LAST_INSERT_ID()']
    end

    class << self
      def table(name=nil)
        @table ||= name
      end

      def fields(*args)
        args.each do |field|
          attr_accessor(field)
        end
        @fields ||= args
      end

      def find(id)
        sql = "SELECT * FROM #{table} WHERE id='#{id}' LIMIT 1"
        res = @@db.query(sql)
        res.map(&method(:new)).first
      end

      def find_by(field, value)
        value = @@db.escape(value)
        sql = <<-SQL
          SELECT * FROM #{table}
          WHERE #{field}='#{value}'
          LIMIT 1
        SQL
        res = @@db.query(sql)
        res.map(&method(:new)).first
      end

      def all
        sql = "SELECT * FROM #{table}"
        res = @@db.query(sql)
        res.map(&method(:new))
      end

      def count
        sql = "SELECT COUNT(*) FROM #{table}"
        res = @@db.query(sql)
        res.first['COUNT(*)']
      end

      def destroy(id)
        record = find(id)
        sql = <<-SQL
          DELETE FROM #{table}
          WHERE id=#{record.id}
        SQL
        @@db.query(sql)
        record
      end

      def destroy_all
        sql = "TRUNCATE #{table}"
        @@db.query(sql)
      end
    end
  end
end

