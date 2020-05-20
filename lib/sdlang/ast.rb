module SDLang
  module AST
    Integer = Struct.new(:int) do
      def eval; int.to_i; end
    end

    String = Struct.new(:string) do
      def eval; string.to_s; end
    end

    Boolean = Struct.new(:value) do
      def eval; value; end
    end

    Tag = Struct.new(:name, :namespace, :values, :attributes, :children) do
      def eval
        Tag.new(
          name.to_s,
          namespace.to_s,
          values.map(&:eval),
          attributes.map(&:eval),
          children.nil? ? nil : children.map(&:eval)
        )
      end
    end

    Attribute = Struct.new(:name, :value) do
      def eval
        Attribute.new(
          name.to_s,
          value.eval
        )
      end
    end
  end
end
