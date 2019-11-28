# GitMQ : Git Message Queue

Hey, Crazy idea bad pitch, lets use Git as a messaging queue! lets use github to
synchronize a cluster of them together.

![Screenshot-2019-11-24_22-41-55](https://user-images.githubusercontent.com/54403/69502136-09672400-0f0c-11ea-8707-df3164411c4e.png)


Lets get the obvious out of the way.

1. You already know that we use Git to keep track of our code changes, If you're a
developer you most probably use it every day, and you probably know how to share
your code changes with everybody else using some central repo server like Github
or Bitbucket.

1. Alright, now lets introduce another idea: **Git commits doesn't need to include
changes**, You don't have to create files then commit these files to
your git repo, you can create an empty commit with a command like this:

```
git commit --allow-empty -m "commit message"
```

1. OK, so the commit message can be any text right? that means you can have JSON
messages or YAML or any other machine readable format as a commit message.

## Now imagine this use case:

1. Create a repository on github
1. Clone it to your server
1. Have your application commit a `message` to this repo every time you need to
1. Push the repo every period say 10 seconds
1. Clone same repo to another server
1. Have an application pull periodically and checks for new commits and for each
   one of them extracts the message and process it
1. Put a git tag on the last processed message with that consumer identifier
1. Push that label to keep track of the last processed message (pull it when you
   deploy that consumer again)

Now you have a queue of messages that can't be altered, communicated between
servers and all data saved in a git repository.

This idea is flexible and can be altered for several use cases:

1. the central server doesn't have to be Github or a like, you can use your
   own server as a git server.
1. You can have more than one queue for messages by creating many branches each
   for a type of messages or a different messages purpose.
1. You can have the same branch consumed from different servers each message
   processed multiple times in different ways like RabbitMQ fanout strategy
1. You can keep browse your message queue with any git client UI or CLI
1. You can clean your servers git local repo so that it deletes old commit
   history to save space.
1. You can have many messages producers write to different branches in the same
   repository
1. In the future you can join 2 branches or split a branch and have your
   consumers adapt to that


There are many advantages to use this approach, which is inherited from how Git
is designed

1. Every message has an address (git commit hash)
1. Every message can be traced to an author which is the application that
   published it (you can use different names for each server or application
   version)
1. Every message has a creation date

This idea can as simple as invoking git commands from your application with a
system call, or use libgit to manipulate the repository for you, or even a small
server application that communicate over a socket, or a repo service that
communicate over even HTTP, there are so many ways to implement that concept.

The current repository is an implementation of this concept in Ruby.

# Installation

Install the gem with
```
gem install gitmq
```

or add gitmq to your `Gemfile`
```
gem 'gitmq', '~> 0.1'
```


# Producing messages

First create an instance of `GitMQ::Storage`, to specify your storage place.

```ruby
storage = GitMQ::Storage.new('/tmp/gitmq')
```

This is where your git repository will live, message producer will use this
storage instance to write messages to any branch you wish.

```ruby
producer = GitMQ::Producer.new(storage: storage, branch: 'master')
```

Now you can use `producer` to publish message to this branch.

```ruby
producer.publish('Hello, world!')
```

It will create a commit with `Hello, world!` as a message in the `master`
branch.

You can have as many producers as you wish for any number of branches, make sure
to have one producer per branch to prevent race conditions between producers.

# Consuming messages

You need to create storage instance as we did with the producer, then
instanciate your consumer

```ruby
consumer = GitMQ::Consumer.new(storage: storage, name: 'consumer', branch:
'master')
```

And start the consume process, this function will take a block of code that
accept one parameter which is your message, this function is non-blocking
it will execute the block of code each time a new commit appear in the branch

```ruby
consumer.consume do |message|
    puts message
end
```

After your block finish execution the consumer will tag this commit with a git
tag, the tag name will be the consumer name, if your consumer name is
`consumer1`, the tag will be `consumer1`, as git tags are global to all the
repository you need to make the consumer name unique not just for the branch but
for all the repository, so if you want to consume 2 branches from one consumer
you'll have to choose to different names so that tags are not overriden be every
consumer instance, you can adopt a naming scheme that involve the branch name,
while implementing this gem we had that name tag name as `branch.consumer` but
then thought it'll be better for the user to make this decision to allow for a
more flexible naming, the tag will be overritten after each time the consumer
process a message.

# Pushing and Pulling your data

As for now there is no way to push/pull from the gem, so this part is up to you,
until it's implemented in the gem.

# Gem executables

## gitmq-produce

Starts a process that waits you to enter any line and publish that as a message

Usage:

```
gitmq-produce /path/to/rpo branch-name
```

## gitmq-consume

Starts a process that waits for messages, each message will be written to the
terminal

Usage:

```
gitmq-consume /path/to/repo branch-name consumer-name
```
