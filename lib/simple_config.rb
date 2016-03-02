require 'yaml'
require 'erb'
require 'ostruct'

# Module provides access to Config
module SimpleConfig
  def self.method_missing(method)
    config.send(method)
  end

  def self.config
    path = File.expand_path('../../.SimpleConfig.yaml', __FILE__)
    @config ||= YAML.load(ERB.new(File.read(path)).result)
    create_struct(@config)
  end

  def self.create_struct(hash)
    struct = OpenStruct.new
    hash.each do |key, value|
      value = create_struct(value) if value.instance_of? Hash
      struct.send("#{key}=", value)
    end
    struct
  end
end
