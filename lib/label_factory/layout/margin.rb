module LabelFactory
  module Layout
    class Margin
    	include XML::Mapping

    	length_node :size, '@size'
    end
  end
end
