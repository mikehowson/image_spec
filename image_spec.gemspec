
Gem::Specification.new do |s|
  s.name        = 'image_spec'
  s.version     = '0.0.4'
  s.authors     = ["Matt Wynne, Mike Howson"]
  s.description = 'A library of Rspec matchers to allow comparison of similar images'
  s.summary     = "image_spec-#{s.version}"
  s.email       = 'mikehowson@gmail.com'
  s.homepage    = "http://github.com/mikehowson/image_spec"

  s.platform    = Gem::Platform::RUBY
  #s.add_dependency 'cucumber', '~> 0.10.2'
  #s.add_development_dependency 'aruba'

  s.rubygems_version   = "1.4.2"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
