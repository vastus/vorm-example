require 'yaml'
require 'mysql2'

module ORM
  class ORMError < StandardError
  end

  class RecordNotFound < ORMError
  end

  module Validatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    def valid?
      validate!
      errors.empty?
    end

    def validate!
      _validators.each_key do |field|
        _validate!(field)
      end if _validators
    end

    private
    def _validate!(field)
      _validators[field].each do |validator|
        if msg = validator.call(self)
          @errors[field] << msg
        end
      end
    end

    def _validators
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
        send("#{attr}=", value)
      end if params
    end

    def table
      self.class.table
    end

    def fields
      self.class.fields
    end

    def update_attribute(key, value)
      send("#{key}=", value) if key
    end

    def update_attributes(hash)
      hash.each { |k, v| update_attribute(k, v) }
    end

    # persistable
    def new_record?
      !id
    end

    # persistable
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
      attrs = _find(_last_id)
      update_attributes(attrs)
      true
    end

    # persistable
    def update(params)
      if new_record?
        return false
      end
      # throw this in update_attrs
      params.keys.each do |k|
        update_attribute(k, params[k])
        _validate!(k)
      end
      if errors.empty?
        update_with(id, params.keys, params.values)
        return true
      else
        return false
      end
    end

    # persistable
    def update_with(id, k, v)
      v = v.map { |v| @@db.escape(v) }
      s = k.zip(v).map { |s| "#{s[0]}='#{s[1]}'" }.join(', ')
      sql = <<-SQL
        UPDATE #{table}
        SET #{s}
        WHERE id=#{id}
      SQL
      @@db.query(sql)
      update_attributes(_find(id)) 
    end

    private
    # refactor
    def _last_id
      sql = <<-SQL
        SELECT LAST_INSERT_ID()
        AS id FROM #{table}
        LIMIT 1
      SQL
      res = @@db.query(sql)
      res.first['id']
    end

    def _find(id)
      sql = <<-SQL
        SELECT * FROM #{table}
        WHERE id=#{id}
        LIMIT 1
      SQL
      @@db.query(sql).first
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
        sql = <<-SQL
          SELECT * FROM #{table}
          WHERE id='#{@@db.escape(id.to_s)}'
          LIMIT 1
        SQL
        res = @@db.query(sql).map(&method(:new)).first
        res ? res : raise(RecordNotFound, "#{self} not found with id=#{id}")
      end

      def find_by(field, value)
        value = @@db.escape(value.to_s)
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

