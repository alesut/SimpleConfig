require 'yaml'
require 'erb'
require 'ostruct'

# Module provides access to Config
module SimpleConfig
  # Config class
  class Config
    def initialize
      @config = yml_conf.merge env_conf
    end

    def get_struct(config = @config)
      struct = OpenStruct.new
      config.each do |key, value|
        value = get_struct(value) if value.instance_of? Hash
        struct.send("#{key}=", value)
      end
      struct
    end

    private

    def yml_conf
      path = File.expand_path(Dir.pwd + '/.SimpleConfig.yml')
      File.file?(path) ? YAML.load(ERB.new(File.read(path)).result) : {}
    end

    def env_conf
      conf = {}
      ENV.each do |key, value|
        hash = key.split('_').reverse.inject(value) { |a, e| { e.downcase => a } }
        conf.merge! hash if hash.is_a?(Hash)
      end
      conf
    end
  end

  def self.method_missing(method)
    @c ||= Config.new
    @c.get_struct.send(method)
  end
end
