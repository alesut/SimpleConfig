require 'yaml'
require 'erb'
require 'ostruct'

# Module provides access to Config
module SimpleConfig
  # Add methods to Array class
  class Array < ::Array
    def to_sql
      map { |x| '"' + x + '"' }.join ','
    end
  end

  def self.method_missing(method)
    config.send(method)
  end

  def self.config
    path = File.expand_path(Dir.pwd + '/.SimpleConfig.yml')
    @config ||= YAML.load(ERB.new(File.read(path)).result)
    create_struct(@config)
  end

  def self.create_struct(hash)
    struct = OpenStruct.new
    hash.each do |key, value|
      value = case value
              when Hash then create_struct(value)
              when ::Array then Array.new(value)
              else value
              end
      struct.send("#{key}=", value)
    end
    struct
  end
end
