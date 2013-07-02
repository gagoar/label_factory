require 'pdf/writer'
require 'xml/mapping'
require 'xml/mapping/base'

module LabelFactory
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8

  LIBRARY_PATH      = File.join(File.dirname(__FILE__), 'label_factory')
  BATCH_PATH        = File.join(LIBRARY_PATH, 'batch')
  LABEL_PATH        = File.join(LIBRARY_PATH, 'label')
  LAYOUT_PATH       = File.join(LIBRARY_PATH, 'layout')
  TEMPLATE_PATH     = File.join(LIBRARY_PATH, 'template')
  TEMPLATES_PATH    = File.expand_path('../../templates', __FILE__)

  module Batch
    autoload :Base,      File.join(BATCH_PATH, 'base')
  end

  module Template
    autoload :Base,      File.join(TEMPLATE_PATH, 'base')
    autoload :Glabel,    File.join(TEMPLATE_PATH, 'glabel')
  end

  module Label
    autoload :Base,      File.join(LABEL_PATH, 'base')
    autoload :Alias,     File.join(LABEL_PATH, 'alias')
    autoload :Cd,        File.join(LABEL_PATH, 'cd')
    autoload :Round,     File.join(LABEL_PATH, 'round')
    autoload :Rectangle, File.join(LABEL_PATH, 'rectangle')
  end

  module Layout
    autoload :Base,      File.join(LAYOUT_PATH, 'Base')
    autoload :Margin,    File.join(LAYOUT_PATH, 'margin')
    autoload :Line,      File.join(LAYOUT_PATH, 'line')
    autoload :Circle,    File.join(LAYOUT_PATH, 'circle')
  end


 require File.join(LIBRARY_PATH, 'version')
 require File.join(LAYOUT_PATH, 'length')
end
