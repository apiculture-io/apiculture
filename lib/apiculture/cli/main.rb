require "apiculture/cli"

class Apiculture::Cli::Main < Apiculture::Cli::Base
  desc "init [PATH]", "Initializes an Apiculture API definition"
  def init(path=".")
    if path != "." && (File.exists?(path) && !File.directory?(path))
      say "Directory '#{path}' already exists!", :red
      exit(1)
    end

    manifest = Apiculture::Manifest.new(config, File.expand_path(".")) do |m|
      m.name = ask("What is the name of the API?",
                   :default => File.basename(File.expand_path(".")))
      m.descriptor_dir = path
    end
    create_file(Apiculture::Manifest::BASE_NAME) { manifest.to_yaml }

    if path != "."
      Dir.mkdir(path)
      Dir.chdir(path)
    end
  end

  desc "generate [DEST]", "Generate SDK code"
  def generate(dest="apiculture_gen")
    if File.exists?(dest) && !File.directory?(dest)
      say "'#{dest}' is not a directory!", :red
      exit(1)
    end

    empty_directory(dest)

    old_root = destination_root

    manifest.input.invoke_protoc("java", "out.zip")

    manifest.outputs.each do |output|
      # Install the template if it doesn't exist.
      template_registry.install(output.template_uri) if output.template.nil?

      destination = File.join(dest, output.template.name)
      empty_directory(destination)
      inside destination do
        @output = output
        self.source_paths << output.template.path
        instance_exec(output, destination, &output.template.generate_proc)
        self.source_paths.delete(output.template.path)
      end
    end
  end

  desc "configure [TEMPLATE_NAME]", "Configure a template (or all of them)"
  def configure(template=nil)
    manifest.outputs.each do |output|
      # Install the template if it doesn't exist.
      template_registry.install(output.template_uri) if output.template.nil?

      next if !template.nil? && output.template.name != template

      say "Configuring #{output.template.name}:"
      instance_exec output.options, &output.template.configure_options_proc
    end
    manifest.write!
  end

  desc "template SUBCOMMAND ...ARGS", "manage installed templates"
  subcommand "template", Apiculture::Cli::TemplateActions
end
