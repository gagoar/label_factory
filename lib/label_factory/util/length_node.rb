module LabelFactory
  module Util
    class LengthNode < XML::Mapping::SingleAttributeNode

      def initialize_impl(path)
        @path = XML::XXPath.new(path)
      end

      def extract_attr_value(xml)
        @value = default_when_xpath_err{@path.first(xml).text}
    		Layout::Length.new(@value)
      end

      def set_attr_value(xml, value)
        raise "Not a Length: #{value}" unless value.is_a? Layout::Length
        @path.first(xml, ensure_created: true).text = value.value
      end
    end

    XML::Mapping.add_node_class LengthNode
  end
end
