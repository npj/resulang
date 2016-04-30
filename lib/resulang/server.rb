require 'resulang'
require 'rack'
require 'mime/types'

module Resulang
  class Server
    def self.escape(html)
      html.gsub(/\</, '&lt;').gsub(/\>/, '&gt;').gsub(/\"/, '&quot;')
    end

    def self.mime_type(filename)
      if (types = MIME::Types.type_for(filename)).empty?
        'text/plain'
      else
        types.first.content_type
      end
    end

    def self.app
      Resulang::App.new(path: File.expand_path('.'))
    end

    def self.serve_html
      html = app.processor(output: nil, format: :html).process
      headers = {
        'Content-Type'   => 'text/html'
      }
      [200, headers, [html]]
    end

    def self.serve_file(path)
      fullpath = File.expand_path("./#{path}")
      if File.file?(fullpath)
        data = File.read(fullpath)
        headers = {
          'Content-Type' => mime_type(File.basename(path))
        }
        [200, headers, [data]]
      else
        [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
      end
    end

    def self.call(env)
      if env['PATH_INFO'] == '/'
        serve_html
      else
        serve_file(env['PATH_INFO'])
      end
    end
  end
end
