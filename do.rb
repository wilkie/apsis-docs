require 'bundler'
Bundler.require

require_relative 'lib/documentor/collector'
require_relative 'lib/generator'

collection = Documentor::Collector.new

collection.path("../apsis/include/apsis", "h")
collection.parseAndAdd("../apsis/include/apsis.h", "../apsis/include/apsis")

generator = Generator.new(:layout    => "views/layout.haml",
                          :class     => "views/class.haml",
                          :namespace => "views/namespace.haml")

generator.output "docs", collection.root

markdown = File.open("index.md").read

content = Tilt.new("views/layout.haml").render(nil, :title => "Apsis Project",
                                                    :file_prefix => "/apsis-docs/docs/") do
  Tilt.new("views/index.haml").render(nil, :content => markdown)
end

File.open("index.html", "w+") do |file|
  file.write content
end
