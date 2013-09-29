use Rack::Static,
  :urls => ["/images", "/js", "/css"],
  :root => "./"

run lambda { |env|
  path = env["PATH_INFO"]
  if path.start_with? "/apsis-docs"
    path = path.gsub(/^\/apsis-docs/, "")
  end
  path = ".#{path}"
  type = case File.extname(path)
         when '.svg'
           'image/svg+xml'
         when '.css'
           'text/css'
         else
           'text/html'
         end
  [
    200,
    {
      'Content-Type'  => type,
      'Cache-Control' => '/, max-age=86400'
    },
    File.open(path, File::RDONLY)
  ]
}
