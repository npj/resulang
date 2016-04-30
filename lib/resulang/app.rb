module Resulang
  class App
    attr_reader :path, :resume

    def initialize(path:)
      @path = path
      load_app
    end

    def template_path
      File.join(path, 'templates', 'resume.html.erb')
    end

    def processor(output:, format:)
      Processor.new(app: self, output: output, format: format)
    end

    class Processor
      attr_reader :app, :output, :format

      def initialize(app:, output:, format:)
        @app    = app
        @output = output
        @format = format
      end

      def filename
        File.extname(output) == ".#{format}" ? output : "#{output}.#{format}"
      end

      def process
        case format.to_sym
          when :html then process_html
        end
      end

      private

        def process_html
          Resulang::Template.new(resume: app.resume, path: app.template_path).process
        end
    end

    private

      def load_app
        unless File.directory?('data') && File.directory?('templates')
          raise "no Resulang app found at #{path.inspect}"
        end

        load_sections
        load_resume
      end

      def load_sections
        section_paths.each { |section| require section }
      end

      def load_resume
        @resume = Resulang::Dsl.new(resume_path).resume
      end

      def sections_dir
        File.join(path, 'data', 'sections')
      end

      def section_paths
        Dir[File.join(sections_dir, '**', '*.rb')]
      end

      def resume_path
        File.join(path, 'data', 'resume.rb')
      end
  end
end
