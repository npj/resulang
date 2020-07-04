module Resulang
  class Resume
    @@declared_sections = { }

    attr_reader :sections

    def initialize(&block)
      @sections = { }
      instance_eval(&block)
    end

    def self.declare_section!(name, &declaration_block)
      @@declared_sections[name] = Class.new(Section, &declaration_block)

      define_method(name) do |&instance_block|
        unless @@declared_sections[name]
          raise "Section \"#{name}\" not found"
        end
        @sections[name] = @@declared_sections[name].new(name: name, &instance_block)
      end
    end
  end
end
