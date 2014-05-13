# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  require 'rubygems/tasks'

  Gem::Tasks.new
rescue LoadError => e
  warn e.message
  warn "Run `gem install rubygems-tasks` to install Gem::Tasks."
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError => e
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end

task :test    => :spec
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError => e
  task :yard do
    abort "Please run `gem install yard` to install YARD."
  end
end
task :doc => :yard

desc "Compiles the apiculture extension proto files for ruby"
task :compile_apiculture_extension_protos do
  Dir.chdir("protos") do
    files = Dir["apiculture_extensions.proto"]
    system(*([
      "protoc",
      "-I.",
      "--ruby_out=../lib"
    ] + files))
  end
  EXTENSION_FILE = "lib/apiculture_extensions.pb.rb"
  IMPORT_BLOCK = "require 'google/protobuf/descriptor.pb'"
  contents = File.read(EXTENSION_FILE)
  contents.gsub!(IMPORT_BLOCK, "# #{IMPORT_BLOCK}")
  File.open(EXTENSION_FILE, "w") { |f| f.write(contents) }
end
