
require 'rubygems'
require 'bundler'
Bundler.require

require 'sass/plugin'
require 'compass'
require 'haml'
require 'erb'

Dir.chdir File.dirname(__FILE__)

module App
  extend self

  def style
    # Generate styles
    @style ||=
      Sass::Engine.for_file("styles/main.scss",
        load_paths: Compass::Frameworks::ALL.map {|framework| framework.path + "/stylesheets/" },
        cache_location: "/tmp/sass-cache",
        style: :compressed).render
  end

  def haml(filename)
    helper = Helper.new(filename)
    Haml::Engine.new(File.read(filename)).render(helper, style: style)
  end
end

class Helper
  attr_reader :source_filename
  def initialize(source_filename)
    @source_filename = source_filename
  end

  def block(name, options = {})
    options = " " + options.to_a.map {|i| "#{i.first}=\"#{i.last}\"" } * " "
    haml_concat "{block:#{name}#{options.rstrip}}"
    yield
    haml_concat "{/block:#{name}}"
    self
  end

  def import(filename)
    filename = "#{filename}.haml" unless filename.include?(".")
    App.haml File.expand_path(filename, File.dirname(source_filename))
  end

  def import_custom(filename)
    filename = "#{filename}.html" unless filename.include?(".")
    filename = File.expand_path(filename, File.dirname(source_filename) + "/../custom")
    if not File.exist?(filename)
      STDERR.puts "Ignoring #{filename}"
    else
      File.read filename
    end
  end
end

print App.haml("template/layout.haml")
