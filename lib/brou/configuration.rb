require 'yaml'

module Brou
  class Configuration

    def initialize
      @conf = YAML::load( File.open( File.join(File.dirname(__FILE__), '..', '..', 'config.yml' ) ))
    end

    def method_missing(*args)
      name = args.first if args
      if name
        @conf[name.to_s]
      else
        super
      end
    end
  end
end
