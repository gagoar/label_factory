module LabelFactory
  module Layout
    class Base

    	include XML::Mapping

    	numeric_node :nx, '@nx'
    	numeric_node :ny, '@ny'

    	length_node :x0, '@x0', default_value: '0 pt'
    	length_node :y0, '@y0', default_value: '0 pt'
    	length_node :dx, '@dx', default_value: '0 pt'
    	length_node :dy, '@dy', default_value: '0 pt'

      def per_page
        [nx, ny].reduce(:*)
      end

      def zero_base_per_page
        per_page - 1
      end
   end
  end
end

