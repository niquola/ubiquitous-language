require 'spec_helper'
require 'ostruct'


describe UL::PartsSemanticSort do
  it "sort sentece" do
    sentence =[
      [:second, [:first]],
      [:third, [:second]],
      [:last, [:first]],
      [:first]
    ].map do |p|
      OpenStruct.new(name: p[0], dependencies: p[1] || [])
    end
    sorted = described_class.new(sentence).tsort
    p sorted
    # sorted.should == %w[first second third last].map(&:to_sym)
  end
end
