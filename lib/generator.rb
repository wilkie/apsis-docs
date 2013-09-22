require 'fileutils'

class Generator
  def initialize(options = {})
    @layout    = Tilt.new(options[:layout])
    @class     = Tilt.new(options[:class])
  end

  def output(to, root, prefix = "")
    case root
    when Documentor::Root
      root.namespaces.each{|e| output(to, e, "#{prefix}#{e.name}::")}
      root.classes.each{|e| output(to, e, prefix)}
    when Documentor::Class
      output_file = root.file
      output_file.gsub!(/#{Regexp.escape(File.extname(output_file))}$/, ".html")
      output_dir = File.dirname(output_file)
      FileUtils::mkdir_p "#{to}/#{output_dir}"
      content = @layout.render(root, :title => "Class #{prefix}#{root.name}") do
        @class.render(root, :prefix => prefix,
                            :name => root.name,
                            :file => root.file,
                            :comment => root.comment,
                            :namespaces => root.namespaces,
                            :classes => root.classes,
                            :functions => root.functions)
      end
      File.open("#{to}/#{output_file}", "w+") do |file|
        file.write content
      end
    when Documentor::Namespace
      root.namespaces.each{|e| output(to, e, "#{prefix}#{e.name}::")}
      root.classes.each{|e| output(to, e, prefix)}
    when Documentor::Function
    end
  end
end
