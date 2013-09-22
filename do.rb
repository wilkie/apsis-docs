require 'bundler'
Bundler.require

require_relative 'lib/documentor/collector'
require_relative 'lib/generator'

collection = Documentor::Collector.new

collection.path("../apsis/include/apsis", "h")

generator = Generator.new(:layout => "views/layout.haml",
                          :class  => "views/class.haml")

generator.output "docs", collection.root
