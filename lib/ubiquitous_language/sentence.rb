module UbiquitousLanguage
  class Sentence
    attr_reader :subject

    def initialize(subject)
      @subject = subject
    end

    class PartType
      attr_reader :name
      attr_reader :type
      attr_reader :block

      def initialize(name, type, options = {}, &block)
        @name = name
        @type = name
        @options = options
        @block = block
      end

      def requires
        @options[:requires] || []
      end
    end

    class Part
      attr_reader :name
      attr_reader :part_type
      attr_reader :args

      def initialize(name, args, part_type)
        @name = name.to_sym
        @args = args
        @part_type = part_type
      end

      def requires
        part_type.requires
      end

      def block
        part_type.block
      end
    end

    class << self
      def parts
        @parts ||= {}
      end

      def object(name, options = {}, &block)
        type = :object
        parts[name] = PartType.new(name, type, options, &block)
      end

      def verb(name, options = {}, &block)
        type = :verb
        parts[name] = PartType.new(name, type, options, &block)
      end

      def pre_condition(name, options = {}, &block)
        type = :pre_condition
        parts[name] = PartType.new(name, type, options, &block)
      end

      def post_action(name, options = {}, &block)
        type = :post_action
        parts[name] = PartType.new(name, type, options, &block)
      end
    end

    def sentence
      @_sentence_ ||= []
    end

    def sentence_tsorted
      PartsSemanticSort.new(self.sentence).tsort
    end

    def respond_to?(name)
      self.class.parts.key?(name) || super
    end

    def method_missing(name, *args)
      super unless part_type = self.class.parts[name.to_sym]
      sentence.push Part.new(name,args, part_type)
      self
    end

    def eval!
      puts "\nEval sentence:"
      sentence_tsorted.each do |part|
        puts "  - #{part.name}"
        self.instance_exec(*part.args, &part.block)
      end
      puts
    rescue => e
      puts "  ! Chain is broken by #{e}"
      raise
    end
  end
end
