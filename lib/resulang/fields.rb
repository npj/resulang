module Resulang
  module Fields
    def self.included(base)
      base.extend(ClassMethods)
    end

    class Email < String
    end

    class Link < String
    end

    class PointList
      attr_reader :points

      def initialize(string: nil, &block)
        @string = string
        @points = [ ]
        instance_eval(&block) if block
      end

      def point(string, &block)
        points.push(PointList.new(string: string, &block))
      end

      def to_s
        @string
      end
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

      protected def list(*attrs)
        fields(*attrs) { |value| Array(value) }
      end

      protected def range(*attrs)
        fields(*attrs) { |*values| (values.first..values.last) }
      end

      protected def pointlist(*attrs)
        fields(*attrs) { |&block| PointList.new(&block) }
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
