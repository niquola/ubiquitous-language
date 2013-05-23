require 'tsort'
module UbiquitousLanguage
  class PartsSemanticSort
    include TSort

    def initialize(collection)
      @collection = collection
    end

    def tsort_each_node(&block)
      p @collection
      @collection.each(&block)
    end

    def tsort_each_child(node, &block)
      @collection.select do |item|
        item.name == node.name
      end.first.dependents.each(&block)
    end
  end
end
