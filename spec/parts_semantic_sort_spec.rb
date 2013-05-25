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
      OpenStruct.new(name: p[0], requires: p[1] || [])
    end
    sorted = described_class.new(sentence).tsort
    sorted.map(&:name).should == %w[first second third last].map(&:to_sym)
  end
end
