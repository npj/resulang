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
        unless File.directory?('templates')
          raise "no Resulang app found at #{path.inspect}: 'templates' directory not found."
        end

        load_resume
      end

      def load_resume
        @resume = Resulang::Resume.new(path: resume_path)
      end

      def resume_path
        File.join(path, 'resume.yaml')
      end
  end
end
