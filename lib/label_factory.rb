require 'pdf/writer'
require 'xml/mapping'
require 'xml/mapping/base'
require 'iconv'
require 'forwardable'

module LabelFactory

  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8

  LIBRARY_PATH      = File.join(File.dirname(__FILE__), 'label_factory')
  BATCH_PATH        = File.join(LIBRARY_PATH, 'batch')
  LABEL_PATH        = File.join(LIBRARY_PATH, 'label')
  LAYOUT_PATH       = File.join(LIBRARY_PATH, 'layout')
  TEMPLATE_PATH     = File.join(LIBRARY_PATH, 'template')
  UTIL_PATH         = File.join(LIBRARY_PATH, 'util')
  TEMPLATES_PATH    = File.expand_path('../../templates', __FILE__)

  module Batch
    autoload :Base,      File.join(BATCH_PATH, 'base')
  end

  module Template
    autoload :Base,      File.join(TEMPLATE_PATH, 'base')
    autoload :Glabel,    File.join(TEMPLATE_PATH, 'glabel')
  end

  module Label
    %w(base alias cd round rectangle).each do |lib|
      autoload lib.capitalize.to_sym, File.join(LABEL_PATH, lib)
    end
  end

  module Layout
    %w(base margin line circle length).each do |lib|
      autoload lib.capitalize.to_sym, File.join(LAYOUT_PATH, lib)
    end
  end

 require File.join(LIBRARY_PATH, 'version')
 require File.join(UTIL_PATH, 'length_node')

end
