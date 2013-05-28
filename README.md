# UbiquitousLanguage

*This is very very alpha version of gem!*

## Mission

Gem for implementing domain drive development.

Key idea of Domain Driven Design is *UbiquitousLanguage*.

  Ubiquitous Language is the term Eric Evans uses in Domain Driven Designfor
  the practice of building up a common, rigorous language between developers and users.
  This language should be based on the Domain Model used in the software -
  hence the need for it to be rigorous, since software doesn't cope well with ambiguity.

  Evans makes clear that using the ubiquitous language between in conversations
  with domain experts is an important part of testing it, and hence the domain model.
  He also stresses that the language (and model) should evolve as the team's understanding of the domain grows.

Martin Fowler (http://martinfowler.com/bliki/UbiquitousLanguage.html)

*UbiquitousLanguage* by definition should be used everywhere, including code.

The most advanced usage of *UbiquitousLanguage* is not only using Nouns for naming classes,
but building valid domain sentences using this language.

The core idea of this gem, allow reflect such sentences in code.

Some ideas also drawn from DCI, User Story, Use Cases and Services Pattern.

## Example

We try to convert Use Case or User Story
into ruby monadic chain
as close to original text as possible
communicating key domain points:

```
  result = user.as(Author)
  .if_rating_allows
  .create
  .new_post(attrs)
  .for_category(category_id)
  .notifying_followers
  .so_that('I share my ideas with other world')

```

and after that, we write code behind (dsl, grammar):

```
  class Author < UL::Sentence
    attr_reader :post
    attr_reader :category

    object :new_post do |attrs|
      @post = Post.new(attrs)
    end

    object :for_category do |category_name|
      @category = Category.find_or_create_by_name(category_name)
    end

    pre_condition :if_rating_allows do
      if subject.rating < 100
	raise "Your rating is too low"
      end
    end

    verb :create,
      requires: %w[new_post for_category] do

      @category.posts<< @post
      @post.save

    end

    post_action :notifying_followers,
      requires: [:create] do
      enqueue('post.new', @post.id, subject.followers)
    end
  end

```

## Installation

Add this line to your application's Gemfile:

    gem 'ubiquitous_language'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ubiquitous_language

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
