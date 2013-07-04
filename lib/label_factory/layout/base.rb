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

      def labels_per_page
        [nx, ny].reduce(:*)
      end

      def labels_base_per_page
        labels_per_page - 1
      end

      def as_pts(attr = nil)
        self.public_send(attr.to_s).as_pts if attr
      end

    end
  end
end

