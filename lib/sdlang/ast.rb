module SDLang
  module AST
    IntLit = Struct.new(:int) do
      def eval; int.to_i; end
    end

    StringLit = Struct.new(:string) do
      def eval; string.to_s; end
    end

    Tag = Struct.new(:name, :values, :attributes, :body) do
      def eval
        Tag.new(
          name.to_s,
          values.map(&:eval),
          attributes.map(&:eval),
          body
        )
      end
    end
  end
end
