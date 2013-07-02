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

    end
  end
end
