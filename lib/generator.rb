require 'fileutils'

class Generator
  def initialize(options = {})
    @layout    = Tilt.new(options[:layout])
    @class     = Tilt.new(options[:class])
    @namespace = Tilt.new(options[:namespace])
  end

  def output(to, root, prefix = "")
    case root
    when Documentor::Root
      root.namespaces.each{|e| output(to, e, "#{prefix}")}
      root.classes.each{|e| output(to, e, prefix)}
    when Documentor::Class
      output_file = root.file
      if output_file
        output_file = output_file.gsub(/#{Regexp.escape(File.extname(output_file))}$/, ".html")
        output_dir = File.dirname(output_file)
        FileUtils::mkdir_p "#{to}/#{output_dir}"
      end

      root.namespaces.each{|e| output(to, e, "#{prefix}")}
      root.classes.each{|e| output(to, e, prefix)}

      class_content = @class.render(root, :prefix => prefix,
                                          :file_prefix => "/apsis-docs/docs/",
                                          :name => root.name,
                                          :file => root.file,
                                          :comment => root.comment,
                                          :namespaces => root.namespaces,
                                          :classes => root.classes,
                                          :functions => root.functions)

      content = @layout.render(root, :title => "Class #{prefix}#{root.name}") do
                  class_content
                end

      if output_file
        File.open("#{to}/#{output_file}", "w+") do |file|
          file.write content
        end
      end
    when Documentor::Namespace
      root.namespaces.each{|e| output(to, e, "#{prefix}#{root.name}::")}
      root.classes.each{|e| output(to, e, "#{prefix}#{root.name}::")}

      namespace_content = @namespace.render(root, :prefix => prefix,
                                                  :file_prefix => "/apsis-docs/docs/",
                                                  :name => root.name,
                                                  :file => root.file,
                                                  :comment => root.comment,
                                                  :namespaces => root.namespaces,
                                                  :classes => root.classes,
                                                  :functions => root.functions)

      content = @layout.render(root, :title => "Namespace #{prefix}#{root.name}") do
                  namespace_content
                end


      path = root.safe_path_from_module_name(prefix)
      FileUtils.mkdir_p "#{to}/namespaces/#{path}"
      File.open("#{to}/namespaces/#{path}.html", "w+") do |file|
        file.write content
      end
    when Documentor::Function
    end
  end
end