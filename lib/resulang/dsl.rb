module Resulang
  class Dsl
    attr_reader :path

    def self.register_section!(section, klass)
      define_section_method(section, klass)
    end

    def initialize(path)
      @path    = path
      @resume = Resume.new
    end

    def resume
      unless @evaluated
        instance_eval(File.read(path))
        @evaluated = true
      end

      @resume
    end

    private

      def self.define_section_method(section, klass)
        define_method(section) do |&block|
          @resume.sections[section.to_sym] = klass.new(&block)
        end
      end
  end
end
