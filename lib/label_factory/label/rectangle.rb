module LabelFactory
  module Label

    class Rectangle < Base
      length_node :width, '@width'
      length_node :height, '@height'
      length_node :round, '@round', default_value: '0 pt'
      length_node :waste, '@waste', default_value: '0 pt'
      length_node :x_waste, '@x_waste', default_value: '0 pt'
      length_node :y_waste, '@y_waste', default_value: '0 pt'
      @kind = 'Rectangle'

    end
  end
end
