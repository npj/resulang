module Resulang
  class Dsl
    attr_reader :path, :resume

    def initialize(path)
      @resume = nil
      @path   = path
      instance_eval(File.read(path))
    end

    private

      # defines the sections and their typed fields
      class Structure
        def initialize(&block)
          instance_eval(&block)
        end

        def section(name, &block)
          Resume.declare_section!(name, &block)
        end
      end

      def structure(&block)
        Structure.new(&block)
      end

      def data(&block)
        @resume = Resume.new(&block)
      end
  end
end
