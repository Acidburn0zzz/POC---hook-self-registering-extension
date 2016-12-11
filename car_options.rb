require './hook.rb'

module CarOptions
  module_function

  def configure
    interior = CarInterior.new
    Hook.(:inherited, on: CockpitOption::Base, to: interior, with: :register_extension)

    puts 'Before customization of interior:'
    interior.print

    puts 'After customization of interior:'
    interior.customize
    interior.print

    self
  end

  module CockpitOption
    class Base; end
  end

  module EngineOption
    class Base; end
  end

  class CarInterior
    def initialize
      @self_registered_extensions = {}
    end

    def customize
      # Let's just load an extension and see what's happening
      load_extension 'sunroof'
    end

    def print
      puts @self_registered_extensions
    end

    # @param [Class] constant to register
    # @return [Class] the received constant
    def register_extension(extension)
      extension_name = @self_registered_extensions.key(nil)
      raise 'Unexpected extension registration' if extension_name.nil?
      @self_registered_extensions[extension_name] = extension
    end

    private

    # Load an extension from its filename
    #
    # @param name [String] filename
    # @return [Boolean] require succeed?
    def load_extension(name)
      @self_registered_extensions[name] = nil
      require "./#{name}.rb"
    end
  end
end

CarOptions.configure
