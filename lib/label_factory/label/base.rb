module LabelFactory
  module Label
    class Base
      include XML::Mapping

      attr_accessor :shape

      numeric_node :id, '@id'

      array_node :markupMargins,  'Markup-margin',  class: Layout::Margin,  default_value: nil
      array_node :markupCircles,  'Markup-circle',  class: Layout::Circle,  default_value: nil
      array_node :markupLines,    'Markup-line',    class: Layout::Line,    default_value: nil

      array_node :layouts, 'Layout', class: Layout::Base

      def markups
        @markups ||= [@markupMargins, @markupLines, @markupCircles ].reduce(:merge)
      end

      def draw_markups!(pdf_instance = nil, box_x, box_y)
        if pdf_instance
          draw_margins!(pdf_instance, box_x, box_y)
          draw_lines!(pdf_instance, box_x, box_y)
        end
      end

      private

      def draw_margins!(pdf_instance = nil, box_x, box_y)
          @markupMargins.each do |margin|
            pdf_instance.rounded_rectangle( box_x + margin.size.as_pts, box_y - margin.size.as_pts,
                                           width_size(margin), height_size(margin), round.as_pts ).stroke
          end
      end

      def draw_lines!(pdf_instance = nil, box_x, box_y)
          @markupLines.each do |line|
            pdf_instance.line(box_x + line.x1.as_pts, box_y + line.y1.as_pts,
                              box_x + line.x2.as_pts, box_y + line.y2.as_pts).stroke
          end
      end

      def width_size(margin)
        width.as_pts - [2,margin.size.as_pts].reduce(:*)
      end

      def height_size(margin)
        height.as_pts - [2, margin.size.as_pts].reduce(:*)
      end
    end
  end
end
