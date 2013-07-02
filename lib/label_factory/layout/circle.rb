module LabelFactory
  module Layout
    class Circle
    	include XML::Mapping

    	length_node :x0, '@x0'
    	length_node :y0, '@y0'
    	length_node :radius, '@radius'
    end
  end
end
