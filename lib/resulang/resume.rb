require 'psych'

module Resulang
  class Resume
    attr_reader :sections

    def initialize(path:)
      @sections = OpenStruct.new
      load_yaml(path)
    end

    private def load_yaml(path)
      Psych.load_file(path).each do |section_name, section_data|
        @sections[section_name] = Section.new(name: section_name, data: section_data)
      end
    end
  end
end
