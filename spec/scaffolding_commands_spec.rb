require 'pathname'
require 'yaml'
require_relative '../lib/generators/common_generator'
require_relative '../lib/commands/scaffolding_commands'
require_relative '../lib/scaffolding/scaffolding'
require_relative 'spec_helper'

describe ScaffoldingCommands do
  let(:scaffold) { described_class }
  let(:name) { 'test' }

  orig_dir = Dir.pwd

  after do
    Dir.chdir orig_dir
  end

  context 'with a spec folder' do
    let(:new_path) { 'test_folder' }

    path = "#{FRAMEWORKS.last}_#{AUTOMATION_TYPES[2]}"

    before do
      Dir.chdir path
    end

    it 'scaffolds for rspec creating a spec' do
      scaffold.new.invoke(:scaffold, nil, %W[#{name}])
      expect(Pathname.new("spec/#{name}_spec.rb")).to be_file
    end

    it 'scaffolds for rspec creating a page' do
      scaffold.new.invoke(:scaffold, nil, %W[#{name}])
      expect(Pathname.new("page_objects/pages/#{name}_page.rb")).to be_file
    end

    it 'deletes a spec' do
      scaffold.new.invoke(:spec, nil, %w[login --delete])
      expect(Pathname.new('spec/login_spec.rb')).not_to be_file
    end

    it 'deletes a helper' do
      scaffold.new.invoke(:helper, nil, %w[driver --delete])
      expect(Pathname.new('helpers/driver_helper.rb')).not_to be_file
    end

    it 'creates a page' do
      scaffold.new.invoke(:page, nil, %W[#{name}])
      expect(Pathname.new("page_objects/pages/#{name}_page.rb")).to be_file
    end

    it 'changes the path for specs' do
      scaffold.new.invoke(:path, nil, %W[#{path} -s])
      config = YAML.load_file('config/config.yml')
      expect(config['spec_path']).to eql path
    end

    it 'updates the url' do
      scaffold.new.invoke(:url, nil, %w[test.com])
      config = YAML.load_file('config/config.yml')
      expect(config['url']).to eql 'test.com'
    end

    it 'updates the browser' do
      scaffold.new.invoke(:browser, nil, %w[:firefox])
      config = YAML.load_file('config/config.yml')
      expect(config['browser']).to eql ':firefox'
    end

    it 'updates the browser options' do
      scaffold.new.invoke(:browser, nil, %w[:firefox --opts headless start-maximized start-fullscreen])
      config = YAML.load_file('config/config.yml')
      expect(config['browser_options']).to eql %w[headless start-maximized start-fullscreen]
    end

    it 'creates a page with a path' do
      scaffold.new.invoke(:page, nil, %W[#{name} --path #{new_path}])
      expect(Pathname.new("#{new_path}/#{name}_page.rb")).to be_file
    end

    it 'creates a spec' do
      scaffold.new.invoke(:spec, nil, %W[#{name} --path #{new_path}])
      expect(Pathname.new("#{new_path}/#{name}_spec.rb")).to be_file
    end
  end

  context 'with a features folder' do
    let(:new_path) { 'test_folder' }

    path = "#{FRAMEWORKS.first}_#{AUTOMATION_TYPES.last}"

    before do
      Dir.chdir path
    end

    it 'scaffolds for cucumber creating a feature' do
      scaffold.new.invoke(:scaffold, nil, %W[#{name}])
      expect(Pathname.new("features/#{name}.feature")).to be_file
    end

    it 'scaffolds for cucumber creating a page' do
      scaffold.new.invoke(:scaffold, nil, %W[#{name}])
      expect(Pathname.new("page_objects/pages/#{name}_page.rb")).to be_file
    end

    it 'creates a helper' do
      scaffold.new.invoke(:helper, nil, %W[#{name}])
      expect(Pathname.new("helpers/#{name}_helper.rb")).to be_file
    end

    it 'deletes a page' do
      scaffold.new.invoke(:page, nil, %w[login --delete])
      expect(Pathname.new('page_objects/pages/login_page.rb')).not_to be_file
    end

    it 'deletes a feature' do
      scaffold.new.invoke(:feature, nil, %w[login --delete])
      expect(Pathname.new('features/login.feature')).not_to be_file
    end

    it 'changes the path for pages' do
      scaffold.new.invoke(:path, nil, %W[#{path}])
      config = YAML.load_file('config/config.yml')
      expect(config['page_path']).to eql path
    end

    it 'changes the path for features' do
      scaffold.new.invoke(:path, nil, %W[#{path} -f])
      config = YAML.load_file('config/config.yml')
      expect(config['feature_path']).to eql path
    end

    it 'updates only the browser options' do
      scaffold.new.invoke(:browser, nil, %w[:firefox --opts headless])
      config = YAML.load_file('config/config.yml')
      expect(config['browser_options']).to eql %w[headless]
    end

    it 'deletes the browser options when passed with the delete parameter' do
      scaffold.new.invoke(:browser, nil, %w[:firefox --opts headless --delete])
      config = YAML.load_file('config/config.yml')
      expect(config['browser_options']).to be_nil
    end

    it 'deletes the browser options' do
      scaffold.new.invoke(:browser, nil, %w[:firefox --opts headless])
      scaffold.new.invoke(:browser, nil, %w[--delete])
      config = YAML.load_file('config/config.yml')
      expect(config['browser_options']).to be_nil
    end

    it 'creates a feature' do
      scaffold.new.invoke(:feature, nil, %W[#{name} --path #{new_path}])
      expect(Pathname.new("#{new_path}/#{name}.feature")).to be_file
    end

    it 'creates a helper with a path' do
      scaffold.new.invoke(:helper, nil, %W[#{name} --path #{new_path}])
      expect(Pathname.new("#{new_path}/#{name}_helper.rb")).to be_file
    end
  end
end
