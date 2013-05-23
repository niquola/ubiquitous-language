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
    @post = Post.new(attrs)
  end

  object :for_category do |category_name|
    @category = Category.find_or_create_by_name(category_name)
  end

  pre_condition :if_carma_allows, "Get more carma points" do
    subject.carma > 100
  end

  verb :create,
    require: %w[new_post for_category] do
    @category.posts<< @post
    @post.save
    @post
  end

  post_action :notifying_followers,
    require: [:new_post,[:create]] do
    enqueue('new.post', @post.id, subject.followers.pluck(:id))
  end

  protected

  def enqueue(queue, *args)
  end
end

describe Author do
  let(:user) { User.new('Afonasij') }

  it "build sentece" do
    user.as(Author).should be_a(Author)

    sentece = user.as(Author)
    .if_carma_allows
    .create
    .new_post(title: 'Ubiquitous Language', content: 'About DDD')
    .for_category('Domain Driven Design')
    .notifying_followers

    sentece.sentece.should_not be_empty

    sentece.eval!

    # sentece = user.as(Author)
    # .create
    # .new(Post, title: 'UL', content: 'About DDD')
    # .notifying_followers

  end
end
