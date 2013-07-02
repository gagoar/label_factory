module LabelFactory
  module Template
    class Base
      include XML::Mapping

      DEFAULT = 'avery-us-templates.xml'

      attr_accessor :labels

      text_node   :name,         '@name'
      text_node   :size,         '@size'
      text_node   :description,  '@description',  default_value: ''
      text_node   :_description, '@_description', default_value: ''

      length_node :width,        '@width',        default_value: nil
      length_node :height,       '@height',       default_value: nil

      #TODO this could be cleaner, but I'm not sure how yet
      hash_node :rectangles, 'Label-rectangle', '@id', class: Label::Rectangle, default_value: nil
      hash_node :rounds,     'Label-round',     '@id', class: Label::Round,     default_value: nil
      hash_node :cds,        'Label-cd',        '@id', class: Label::Cd,        default_value: nil

      hash_node :alias, 'Alias', '@name', class: Label::Alias, default_value: Hash.new

      def initialize

      end

      def labels
        @labels ||= [ @rectangles, @rounds, @cds ].reduce(:merge)
      end

      def nx
        first_layout.nx if first_layout
      end

      def ny
        first_layout.ny if first_layout
      end

      def find_description
        _description || description
      end

     private

     def first_layout
        label = labels['0']
        label.layouts.first if label
      end
    end
  end
end
