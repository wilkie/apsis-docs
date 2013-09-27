use Rack::Static,
  :urls => ["/images", "/js", "/css"],
  :root => "./"

run lambda { |env|
  path = env["PATH_INFO"]
  if path.start_with? "/apsis-docs"
    path = path.gsub(/^\/apsis-docs/, "")
  end
  path = ".#{path}"
  [
    200,
    {
    'Content-Type'  => 'text/html',
    'Cache-Control' => '/, max-age=86400'
  },
    File.open(path, File::RDONLY)
  ]
}
