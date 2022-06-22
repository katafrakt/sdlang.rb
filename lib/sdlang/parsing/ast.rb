require "date"
require "time"
require "tzinfo"

module SDLang
  module AST
    Integer = Struct.new(:int) do
      def eval
        int.to_i
      end
    end

    Float = Struct.new(:float) do
      def eval
        float.to_f
      end
    end

    String = Struct.new(:string) do
      def eval
        string.to_s
      end
    end

    Boolean = Struct.new(:value) do
      def eval
        value
      end
    end

    Date = Struct.new(:date) do
      def eval
        ::Date.strptime(date, "%Y/%m/%d")
      end
    end

    Time = Struct.new(:time, :timezone) do
      def eval
        nt = ::Time.parse(time)
        tz = TZInfo::Timezone.get(timezone.to_s)
        tz.local_time(nt.year, nt.month, nt.day, nt.hour, nt.min, nt.sec, nt.subsec).to_time
      end
    end

    DateTime = Struct.new(:date, :time, :timezone) do
      def eval
        nt = ::DateTime.parse("#{date} #{time}")
        tz = TZInfo::Timezone.get(timezone.to_s)
        tz.local_time(nt.year, nt.month, nt.day, nt.hour, nt.min, nt.sec, nt.second_fraction).to_datetime
      end
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
