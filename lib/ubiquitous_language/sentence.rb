module UbiquitousLanguage
  class Sentence
    attr_reader :subject

    PARTS_WEIGHTS = {object: 1,
                     pre_condition: 2,
                     verb: 3}

    def initialize(subject)
      @subject = subject
    end

    class << self
      def parts
        @parts ||= {}
      end

      def object(name, options = {}, &block)
        parts[name] = [:object, options, block]
      end

      def verb(name, options = {}, &block)
        parts[name] = [:verb, options, block]
      end

      def pre_condition(name, options = {}, &block)
        parts[name] = [:pre_condition, options, block]
      end

      def post_action(name, options = {}, &block)
        parts[name] = [:post_action, options, block]
      end
    end

    def sentece
      @_sentence_
    end

    def respond_to?(name)
      self.class.parts.key?(name) || super
    end

    def method_missing(name,*args)
      super unless self.class.parts.key?(name.to_sym)
      @_sentence_ ||= []
      @_sentence_.push([name,args])
      self
    end

    def eval!
      puts "Good job. Done. \nSentence:\n  #{subject.inspect}\n  #{@_sentence_.map(&:inspect).join("\n  ")}"
      # self.instance_exec(*args,&block)
    end
  end
end
