require 'thor'

module Resulang
  class Exec < Thor
    include Thor::Actions

    desc 'new NAME', 'Generate a new Resulang app in directory NAME'
    option :sections, type: :array, required: false, default: [], desc: 'A list of initial sections to generate'
    def new(name)
      empty_directory(name)
      inside(name) do
        create_file "server.ru" do
          contents = [
            %Q{require "resulang/server"},
            %Q{run Resulang::Server}
          ]
          contents.join("\n")
        end

        create_file('resume.yaml') do
          options[:sections].inject([]) do |list, s|
            list.push("#{s}:")
          end.join("\n\n")
        end

        empty_directory 'css'
        inside('css') do
          create_file('style.css')
        end

        empty_directory 'templates'
        inside('templates') do
          create_file('resume.html.erb') do
            <<-HTML
<html>
  <head>
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body>
    #{options[:sections].map { |section| %Q{<div class="section"><%= render_section(:#{section}) %></div>} }.join("\n    ")}
  </body>
</html>
            HTML
          end
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
