require 'active_support/inflector'

module Resulang
  module Rendering
    include ActiveSupport::Inflector

    def render_section(section)
      if s = sections[section.to_sym]
        ERB.new(File.read(partial(section))).result(s.get_binding)
      end
    end

    def html_escape(str)
      ERB::Util.html_escape(str)
    end

    def partial(name)
      File.expand_path("../_#{name}.html.erb", template_path)
    end
  end
end
