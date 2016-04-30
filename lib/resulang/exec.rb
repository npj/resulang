require 'thor'
require 'active_support/inflector'

module Resulang
  class Exec < Thor
    include Thor::Actions

    desc 'new NAME', 'Generate a new Resulang app in directory NAME'
    option :sections, type: :array, required: false, default: [], desc: 'A list of initial sections to generate'
    def new(name)
      empty_directory(name)
      inside(name) do
        create_file "server.ru" do
          <<-SERVER
            require "resulang/server"
            run Resulang::Server
          SERVER
        end

        empty_directory('data')
        inside('data') do
          create_file('resume.rb') do
            options[:sections].inject([]) { |list, s| list.push("#{s} do\n\nend") }.join("\n\n")
          end

          empty_directory('sections')
          inside('sections') do
            options[:sections].each do |s|
              create_file("#{s}.rb", "class #{ActiveSupport::Inflector.camelize(s)} < Resulang::Section\n\nend")
            end
          end
        end

        empty_directory 'templates'
        inside('templates') do
          create_file('resume.html.erb')
          options[:sections].each do |s|
            create_file("_#{s}.html.erb")
          end
        end
      end
    end

    desc 'server', 'Start a development server'
    def server
      run %{rackup server.ru}
    end

    desc 'make', 'Generate a static HTML file from a Resulang app'
    option :output, type: :string,  default: 'resume', required: false, desc: 'Path to generated HTML'
    option :force,  type: :boolean, default: false,    required: false, desc: 'Ask to overwrite files or not'
    def make
      app       = Resulang::App.new(path: File.expand_path('.'))
      processor = app.processor(output: options[:output], format: :html)
      create_file(processor.filename, force: options[:force]) { processor.process }
    end
  end
end
