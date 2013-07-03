module LabelFactory
  module Template
    class Glabel
      include XML::Mapping

      hash_node :templates, 'Template', '@name', class: Base, default_value: Hash.new

      def find_all_templates
        unless @templates
          @templates = []
          templates.each do |template|
           template = template[1]
            @templates << template.name
            template.alias.each do |aliases|
              @templates << aliases[1].name
            end
          end
        end
        @templates
      end

      def find_template(template_name)
        template = templates.find{|k,v| k == template_name || v.alias[template_name]}
        template[1] if template
      end

      def all_avaliable_templates
        all_templates_names + all_templates_alias_names
      end

      private

      def all_templates_names
        templates.values.map(&:name)
      end

      def all_templates_alias_names
        templates.values.map(&:alias).map(&:keys).flatten
      end

    end
  end
end
