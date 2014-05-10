class Apiculture::Template::Builder
  attr_accessor :template
  def initialize(template)
    @template = template
  end

  attr_accessor :configure_options_proc
  def configure_options(&blk)
    @configure_options_proc = blk
  end

  attr_accessor :generate_proc
  def generate(&blk)
    @generate_proc = blk
  end
end
