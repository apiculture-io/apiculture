require 'spec_helper'

describe Apiculture::Config do
  it "#config_dir" do
    old_dir = Apiculture::Config.config_dir
    instance = Apiculture::Config.new
    expect(Apiculture::Config.config_dir).to eq(old_dir)

    Apiculture::Config.config_dir = new_dir = "/tmp"
    expect(Apiculture::Config.config_dir).to eq(new_dir)
    expect(instance.config_dir).to eq(new_dir)

    Apiculture::Config.reset_config_dir!
    expect(Apiculture::Config.config_dir).to eq(old_dir)
  end
end
