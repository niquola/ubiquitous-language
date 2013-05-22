module UbiquitousLanguage
  module Subject
    def as(sentece)
      sentece.new(self)
    end
  end
end
