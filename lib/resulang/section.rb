require 'ostruct'

module Resulang
  class Section < OpenStruct
    attr_reader :_section_name

    include Rendering

    def initialize(name:, data:)
      super(_section_name: name)
      interpret_object(self, data)
    end

    def get_binding
      binding
    end

    private def interpret(value) 
      if (range = interpret_range(value))
        range
      elsif value.respond_to?(:keys)
        interpret_object(OpenStruct.new, value)
      elsif value.respond_to?(:map)
        value.map { |v| interpret(v) }
      else
        value
      end
    end

    private def interpret_object(struct, value)
      struct.tap do |s|
        value.each do |key, value|
          s[key] = interpret(value)
        end
      end
    end

    private def interpret_range(value)
      if value.respond_to?(:keys) && value.keys == ['range']
        (value['range'].first..value['range'].last)
      end
    end
  end
end
