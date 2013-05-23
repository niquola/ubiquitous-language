require "ubiquitous_language/version"

module UbiquitousLanguage
  # Your code goes here...
  autoload :Sentence, 'ubiquitous_language/sentence'
  autoload :Subject, 'ubiquitous_language/subject'
  autoload :PartsSemanticSort, 'ubiquitous_language/parts_semantic_sort'
end

UL = UbiquitousLanguage
