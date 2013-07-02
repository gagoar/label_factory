module LabelFactory
  module Layout


    class Line
    	include XML::Mapping
    	length_node :x1, "@x1"
    	length_node :y1, "@y1"
    	length_node :x2, "@x2"
    	length_node :y2, "@y2"
    end

    class Circle
    	include XML::Mapping
    	length_node :x0, "@x0"
    	length_node :y0, "@y0"
    	length_node :radius, "@radius"
    end
  end
end
