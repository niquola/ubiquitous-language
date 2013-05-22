require 'spec_helper'

class User
  include UL::Subject
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Author < UL::Sentence
  object :new_post do |attrs|
    @post_attributes = attrs
  end

  verb :create, require: :new_post do
    Post.crate(@post_attributes)
  end

  protected

  def some_helper
  end
end

describe Author do
  let(:user) { User.new('Afonasij') }

  it "build sentece" do
    user.as(Author).should be_a(Author)

    sentece = user.as(Author)
    .create
    .new_post(title: 'UL', content: 'About DDD')

    p sentece.sentece
  end
end
