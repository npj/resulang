require 'active_support/inflector'

module Resulang
  class Section
    include Fields
    include Rendering

    def self.inherited(subclass)
      Resulang::Dsl.register_section!(ActiveSupport::Inflector.underscore(subclass.name), subclass)
    end

    def initialize(&block)
      instance_eval(&block)
    end

    def get_binding
      binding
    end
  end
end
