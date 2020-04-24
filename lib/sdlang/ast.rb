module SDLang
  module AST
    IntLit = Struct.new(:int) do
      def eval; int.to_i; end
    end

    StringLit = Struct.new(:string) do
      def eval; string; end
    end

    Tag = Struct.new(:name, :value) do
      def eval
        Tag.new(name, value.eval)
      end
    end
  end
end
