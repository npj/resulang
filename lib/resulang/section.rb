module Resulang
  class Section
    attr_reader :name

    include Fields
    include Rendering

    def initialize(name:, &block)
      @name = name
      instance_eval(&block)
    end

    def get_binding
      binding
    end
  end
end
