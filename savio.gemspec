require_relative 'lib/savio/version'

Gem::Specification.new do |spec|
  spec.name          = "savio"
  spec.version       = Savio::VERSION
  spec.authors       = ["TheRealSavi"]
  spec.email         = ["JohnGibbons167@gmail.com"]

  spec.summary       = %q{Adds IO Elements to Ruby2D}
  spec.description   = %q{Allows you to easily ask for user input through sliders, buttons, text boxs, etc}
  spec.homepage      = "http://www.gibbonsiv.com"
  spec.license       = "MIT"
  s.metadata         = { "source_code_uri" => "https://github.com/TheRealSavi/savio" }
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "ruby2d", "~> 0.9.2"
end
