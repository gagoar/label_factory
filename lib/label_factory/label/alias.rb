module LabelFactory
  module Label
    class Alias
    	include XML::Mapping

    	text_node :name, '@name'

    end
  end
end
