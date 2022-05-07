# frozen_string_literal: true

require_relative '../lib/generators/files/file_generator'
require_relative 'spec_helper'

describe RubyRaider::RspecFileGenerator do
  before(:all) do
    @name = 'Cucumber-watir-2'
    RubyRaider::CucumberProjectGenerator.generate_cucumber_project('watir', @name)
  end

  it 'creates a feature file' do
    expect(File.exist?("#{@name}/features/login.feature")).to be_truthy
  end

  it 'creates a step definitions file' do
    expect(File.exist?("#{@name}/features/step_definitions/login_steps.rb.rb")).to be_truthy
  end

  it 'creates an env file' do
    expect(File.exist?("#{@name}/features/support/env.rb")).to be_truthy
  end

  after(:all) do
    FileUtils.rm_rf(@name)
  end
end
