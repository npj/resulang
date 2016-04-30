require 'erb'

module Resulang
  class Template < SimpleDelegator
    include Rendering

    # Any 'attr_reader' attributes defined here will be
    # available in the template.
    attr_reader :template_path

    def initialize(resume:, path:)
      @template_path = path

      # Delegate everything else to resume allows code within the template to
      # do things like <%= personal.name %> which is the equivalent of
      # <%= resume.personal.name %>.
      super(resume)
    end

    def process
      ERB.new(File.read(template_path)).result(binding)
    end
  end
end
