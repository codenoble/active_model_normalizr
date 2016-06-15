lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'active_model_normalizr/version'

Gem::Specification.new do |s|
  s.name = 'active_model_normalizr'
  s.version = ActiveModelNormalizr::VERSION
  s.summary = 'An ActiveModelSerializers adapter for Normalizr-like JSON'
  s.description = 'Render your JSON in a Normalizr-like JSON format'
  s.files = Dir['README.*', 'MIT-LICENSE', 'lib/**/*.rb']
  s.require_path = 'lib'
  s.author = 'Adam Crownoble'
  s.email = 'adam@codenoble.com'
  s.homepage = 'https://github.com/codenoble/active_model_normalizr'
  s.license = 'MIT'
  s.add_dependency('active_model_serializers', '~> 0.10.0')
  s.add_development_dependency('activerecord', '~> 4.2')
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency('sqlite3', '~> 1.3')
  s.add_development_dependency('pry')
end
