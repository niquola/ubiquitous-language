require 'tsort'
module UbiquitousLanguage
  class PartsSemanticSort
    include TSort

    def initialize(collection)
      @collection = collection
      @index = {}
      @collection.each do |c|
        @index[c.name.to_sym] = c
      end
    end

    def tsort_each_node(&block)
      @collection.each(&block)
    end

    def tsort_each_child(node, &block)
      node.requires.each do |child_name|
        raise "No #{child_name} in #{@index.keys}" unless @index.key?(child_name.to_sym)
        block.call(@index[child_name.to_sym])
      end
    end
  end
end
