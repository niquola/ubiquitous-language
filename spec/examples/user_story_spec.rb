require 'spec_helper'


class AM
  include UL::Subject
  attr_accessor :id
  def initialize(attrs)
    attrs.each do |attr_name,value|
      self.send("#{attr_name}=",value)
    end
  end

  def save
  end
end

class User < AM
  attr_accessor :name
  attr_accessor :carma
  attr_accessor :followers
end

class Post < AM
  attr_accessor :title
  attr_accessor :content
end

class Category < AM
  attr_accessor :name

  def self.find_or_create_by_name(name)
    Category.new(name: name)
  end

  def posts
    @posts ||= []
  end
end

class Author < UL::Sentence
  attr_reader :post
  attr_reader :category

  object :new_post do |attrs|
    @post = Post.new(attrs)
  end

  object :for_category do |category_name|
    @category = Category.find_or_create_by_name(category_name)
  end

  pre_condition :if_carma_allows do
    if subject.carma < 100
      raise "Your carmas is not enough"
    end
  end

  verb :create,
    requires: %w[new_post for_category] do

    @category.posts<< @post
    @post.save

  end

  post_action :notifying_followers,
    requires: [:create] do
    puts "Creating job for sending to #{subject.followers}"
    enqueue('new.post', @post.id, subject.followers)
  end

  protected

  def enqueue(queue, *args)
    #do some private jobs here
  end
end

describe Author do
  let(:user) { User.new(name: 'Afonasij', carma: 100, followers: %w[ivan andrey]) }

  it "build sentence" do
    user.as(Author).should be_a(Author)

    sentence = user.as(Author)
    .if_carma_allows
    .create
    .new_post(title: 'Ubiquitous Language', content: 'About DDD')
    .for_category('Domain Driven Design')
    .notifying_followers

    sentence.eval!

    sentence.post.title.should == 'Ubiquitous Language'
    sentence.category.posts.should include(sentence.post)

    user.carma = 0
    ->{ sentence.eval!  }
    .should raise_error("Your carmas is not enough")
  end
end
