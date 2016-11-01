require 'yaml'
require 'erb'
require 'ostruct'

# Module provides access to Config
module SimpleConfig
  # Config class
  class Config
    def initialize
      @config = deep_merge(yml_conf, env_conf)
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
        value = typing(value)
        hash = key.split('_').reverse.inject(value) { |a, e| { e.downcase => a } }
        deep_merge(conf, hash) if hash.is_a?(Hash)
      end
      conf
    end

    def typing(value)
      case value
      when 'true' then true
      when 'false' then false
      when value.to_i.to_s then value.to_i
      when value.to_f.to_s then value.to_f
      else value
      end
    end

    def deep_merge(first, second)
      merger = proc do |_key, v1, v2|
        if v1.is_a?(Hash) && v2.is_a?(Hash)
          v1.merge(v2, &merger)
        elsif v1.is_a?(Array) && v2.is_a?(Array)
          v1 | v2
        else
          [:undefined, nil, :nil].include?(v2) ? v1 : v2
        end
      end
      first.merge!(second.to_h, &merger)
    end
  end

  def self.method_missing(method)
    @c ||= Config.new
    @c.get_struct.send(method)
  end
end
