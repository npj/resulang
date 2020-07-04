require 'active_support/inflector'

module Resulang
  module Fields
    def self.included(base)
      base.extend(ClassMethods)
    end

    class Email < String
    end

    class Link < String
    end

    module ClassMethods
      protected def string(*attrs)
        fields(*attrs) { |value| value }
      end

      protected def email(*attrs)
        fields(*attrs) { |value| Email.new(value) }
      end

      protected def link(*attrs)
        fields(*attrs) { |value| Link.new(value) }
      end

      protected def list(*attrs, &item_decl)
        attrs.each do |name|
          define_method(name) do |*args, &block|
            field_get(name)
          end

          singular = ActiveSupport::Inflector.singularize(name)

          define_method(singular) do |*args, &item_def|
            if args.empty? && item_def.nil?
              raise "no arguments or definition block given for list #{singular}"
            end

            items = field_get(name) || []

            if item_def.nil?
              args.each { |a| items.push(a) }
            elsif
              items.push(Class.new(Section, &item_decl).new(name: name, &item_def))
            end

            field_set(name, items)
          end
        end
      end

      protected def range(*attrs)
        fields(*attrs) { |*values| (values.first..values.last) }
      end

      private def fields(*names, &block)
        names.each do |name|
          define_method(name) do |*args, &b|
            if args.empty? && b.nil?
              field_get(name)
            else
              field_set(name, block.call(*args, &b))
            end
          end
        end
      end
    end

    #
    # Instance Methods
    #
    private def field_set(attr, value)
      instance_variable_set("@#{attr}", value)
    end

    private def field_get(attr)
      instance_variable_get("@#{attr}")
    end
  end
end
