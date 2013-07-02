module LabelFactory
  module Label
    class Round < Base

      length_node :radius, '@radius'
      length_node :waste, '@radius', default_value: '0 pt'
      @kind = 'Round'

    end

  end
end
