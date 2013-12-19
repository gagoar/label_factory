module LabelFactory
  module Batch
    class Base

      DEFAULTS = { justification: :left, font_size: 12, font_type: 'Helvetica' }
      CONVERTER = Iconv.new( 'ISO-8859-1//IGNORE//TRANSLIT', 'utf-8')
      attr_accessor :template, :label, :pdf, :manual_new_page

      @@gt = nil

      class << self
        def gt
          @@gt || self.load_template_set
        end

        def load_template_set(template_set_file = nil)
          template_set_file ||= File.join(TEMPLATES_PATH, Template::Base::DEFAULT)
          @@gt = Template::Glabel.load_from_file(template_set_file)
        end

        def all_template_names
          gt.all_avaliable_templates
        end

        def all_templates
          gt.templates.values
        end
      end


      def initialize(template_name, pdf_opts = {})

        @template = gt.find_template(template_name)

        if @template
          @label = @template.label

          @layout = @label.layouts.first

          @pdf = PDF::Writer.new(set_options(pdf_opts))

          @pdf.margins_pt(0, 0, 0, 0)

        else
          raise 'Template not found!'
        end

      end

      def gt
        self.class.gt
      end

      def set_options(opts = {})
        opts[:paper] = @template.size.gsub(/^.*-/,'') if @template.size && ! opts[:paper]
        # set font_dir if needed
        set_fonts(opts.delete(:font_dir)) if opts[:font_dir]
        # set afm_dir if needed
        set_afm_fonts(opts.delete(:afm_dir)) if opts[:afm_dir]

        opts
      end
=begin rdoc
      add_label takes an argument hash.
      [:position]  Which label slot to print.  Positions are top to bottom, left to right so position 1 is the label in the top lefthand corner.  Defaults to 0
      [:x & :y]  The (x,y) coordinates on the page to print the text.  Ignored if position is specified.
      [:text] What you want to print in the label.  Defaults to the (x,y) of the top left corner of the label.
      [:use_margin] If the label has a markupMargin, setting this argument to true will respect that margin when writing text.  Defaults to true.
      [:justification] Values can be :left, :right, :center, :full.  Defaults to :left
      [:offset_x, offset_y] If your printer doesn't want to print with out margins you can define these values to fine tune printout.
=end
      def set_fonts(font_dir = nil)
        PDF::Writer::FONT_PATH << font_dir if font_dir && ! PDF::Writer::FONT_PATH.include?( font_dir )
      end

      def set_afm_fonts(afm_dir = nil)
        PDF::Writer::FontMetrics::METRICS_PATH << afm_dir if afm_dir && ! PDF::Writer::FontMetrics::METRICS_PATH.include?( afm_dir )
      end

      def add_label(text, options = {})
        unless options.delete(:skip)
          label_x, label_y, label_width = setup_add_label_options(options)
          opts = setup(label_x, label_width, options)
          @pdf.y = label_y
        end
        opts ||= options
        @pdf.select_font options[:font_type] if options[:font_type]
        @pdf.text(CONVERTER.iconv(text), opts)
        opts
      end

=begin rdoc
      You can add the same text to many labels this way, takes all the arguments of add_label, but must have position instead of x,y. Requires count.
       [:count] - Number of labels to print
=end

      def add_many_labels(text, options = {})
        if !( options[:x] || options[:y] )
          options[:position] ||= 0
          if options[:count]
            options[:count].times do
              add_label(text, options)
              options[:position] += 1
            end
          else
            raise 'Count required'
          end
        else
          raise "Can't use X,Y with add_many_labels, you must use position"
        end
      end

=begin rdoc
    we needed something handy to write several lines into a single label, so we provide an array with hashes inside, each hash must contain a [:text] key and
    could contain optional parameters such as :justification, and :font_size if not DEFAULTS options are used.
=end
      def add_multiline_label(content = [], position = 0)
        opts = {}
        content.each_with_index do |options, i|
          options = DEFAULTS.merge(options)
          if i.zero?
            opts = options
            opts[:position] = position
          else
            opts[:skip] = true
            opts.merge!(options)
          end
          text = opts.delete(:text)
          opts = add_label(text, opts)
        end
      end

      def draw_boxes(write_coord = true, draw_markups = true)
        pdf.open_object do |heading|
          pdf.save_state
          do_draw_boxes!(write_coord, draw_markups)
          pdf.restore_state
          pdf.close_object
          pdf.add_object(heading, :all_pages)
        end
      end

      def save_as(file_name)
        @pdf.save_as(file_name)
      end

      private
=begin rdoc
      To facilitate aligning a printer we give a method that prints the outlines of the labels
=end
      def do_draw_boxes!(write_coord = true, draw_markups = true)
        @layout.nx.times do |x|
          @layout.ny.times do |y|
            box_x, box_y = get_x_y(x, y)
            @pdf.rounded_rectangle(box_x, box_y, @label.width.as_pts, @label.height.as_pts, @label.round.as_pts).stroke
            add_label('', x: box_x, y: box_y ) if write_coord
            @label.draw_markups!(@pdf, box_x, box_y) if draw_markups
          end
        end
      end

=begin rdoc
      Position is top to bottom, left to right, starting at 1 and ending at the end of the page
=end
      def position_to_x_y(options = {})
        position = options[:position]
        if position && position > @layout.labels_base_per_page
          position = position % @layout.labels_per_page
          @pdf.new_page if position.zero? && !manual_new_page
        end
        x = options[:x] || @layout.get_x(position)
        y = options[:y] || @layout.get_y(position)
        x += options[:offset_x] if options[:offset_x]
        y += options[:offset_y] if options[:offset_y]
        get_x_y(x, y)
      end

      def get_x_y(x, y)
        [ get_label_x_position(x), get_label_y_position(y) ]
      end

      def get_label_x_position(x)
        get_left_label_position + [ x, @layout.as_pts(:dx) ].reduce(:*)
      end

      def get_label_y_position(y)
        get_top_label_position - [ y, @layout.as_pts(:dy) ].reduce(:*)
      end

      def get_left_label_position
        [ @pdf.absolute_left_margin, @pdf.left_margin ].reduce(:-) + @layout.as_pts(:x0)
      end

      def get_top_label_position
        [ @pdf.absolute_top_margin, @pdf.top_margin ].reduce(:+) - @layout.as_pts(:y0)
      end

      def setup_add_label_options(options)

        label_x, label_y = position_to_x_y(options)


        label_x, label_y, label_width = @label.without_margins(label_x, label_y, options[:offset_x]) unless options[:use_margin]

        [ label_x, label_y, label_width ]
      end

      def setup(label_x, label_width, options)
        config = DEFAULTS.merge( { absolute_left: label_x, absolute_right: label_width } )
        config.merge! options
        config.delete(:position)
        config
      end

    end
  end
end
