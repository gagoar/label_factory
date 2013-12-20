# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'label_factory/version'

Gem::Specification.new do |spec|
  spec.name          = 'label_factory'
  spec.version       = LabelFactory::VERSION
  spec.authors       = ['gagoar']
  spec.email         = ['xeroice@gmail.com']
  spec.description   = %q{pdf label creation in ruby}
  spec.summary       = %q{http://github.com/eventioz/label_factory}
  spec.homepage      = %q{http://github.com/eventioz/label_factory}
  spec.license       = %q{MIT}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'eventioz-pdf-writer'
  spec.add_dependency 'xml-mapping' , '0.8.1'
  spec.add_dependency 'iconv'

  #development
  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
end
