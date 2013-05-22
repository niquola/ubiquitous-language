module UbiquitousLanguage
  class Sentence
    attr_reader :subject
    def initialize(subject)
      @subject = subject
    end

    def self.objects
      @objects ||= {}
    end

    def self.object(name, opts = {}, &block)
      objects[name] = [opts, block]
    end

    def self.verbs
      @verbs ||= {}
    end

    def self.verb(name, opts = {}, &block)
      verbs[name] = [opts, block]
    end

    def self.conditions
      @condition ||= {}
    end

    def self.condition(name, opts = {}, &block)
      conditions[name] = [opts, block]
    end

    def sentece
      @_sentence_
    end

    def method_missing(name,*args)
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
