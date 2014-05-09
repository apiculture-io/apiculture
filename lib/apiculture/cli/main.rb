require "apiculture/cli"

class Apiculture::Cli::Main < Apiculture::Cli::Base
  desc "init [PATH]", "Initializes an Apiculture API definition"
  def init(path=nil)
    if path && (File.exists?(path) || File.directory?(path))
      say "Directory '#{path}' already exists!", :red
      exit(1)
    end

    manifest = Apiculture::Manifest.new(config, File.expand_path(".")) do |m|
      m.name = ask("What is the name of the API?")
    end
    maybe_write_file(Apiculture::Manifest::BASE_NAME) { manifest.to_yaml }

    if path
      Dir.mkdir(path)
      Dir.chdir(path)
    end
  end

  desc "template SUBCOMMAND ...ARGS", "manage installed templates"
  subcommand "template", Apiculture::Cli::TemplateActions
end
