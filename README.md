# GitMQueue : Git Message Queue

Hey, Good idea bad pitch, lets use Git as a messaging queue! lets use github to
synchronize a cluster of them together.

Lets get the obvious out of the way, You already know that we use Git to keep
track of our code changes, and we need a central point to pull and push these
changes (although it's designed to be decentralized), this is why we use
github/lab/bitbucket...etc.

Alright, now lets introduce another idea: Git commits doesn't need to include
changes, so you don't have to create files then commit these files to
your git repo, you can create an empty commit with a command like this:

```
git commit --allow-empty -m "commit message"
```

OK, so the commit message can be any text right? that means you can have JSON
messages or YAML or any other machine readable format as a commit message.

So now imagine this scenario:

1. Create a repo on github
1. Clone it to your server
1. Have your application commit a `message` to this repo every time you need to
1. Push the repo every period say 10 seconds
1. Clone same repo to another server
1. Have an application there (consumer) pull periodically
1. Have Another thread there that checks for new commits and for each one of
   them extracts the message and does the job
1. Put a git tag on the last processed message with that consumer identifier
1. Push that label to keep track of the last processed message (pull it when you
   deploy that consumer again)

Now you have a queue of messages that can't be altered, communicated between
servers and all data saved in a git repository.

This idea is flexible and can be modified for several use cases:

1. the central server doesn't have to be a github or a like, you can use your
   own server as a git server.
1. You can have more than one queue for messages by creating many branches each
   for a type of messages or a different messages purpose.
1. You can have the same branch consumed from different servers each message
   processed multiple times in different ways like RabbitMQ fan out strategy
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

# Installation

Install the gem with
```
gem install gitmqueue
```

or add gitmqueue to your `Gemfile`
```
gem 'gitmqueue', '~> 0.1'
```


# Producing messages

First create an instance of `GitMQueue::Storage`, to specify your storage place.

```ruby
storage = GitMQueue::Storage.new('/tmp/gitmqueue')
```

This is where your git repository will live, message producer will use this
storage instance to write messages to any branch you wish.

```ruby
producer = GitMQueue::Producer.new(storage: storage, branch: 'master')
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
consumer = GitMQueue::Consumer.new(storage: storage, name: 'consumer', branch:
'master')
```

And start the consume process, this function will take a block of code that
accept one parameter which is your message, this function will block your thread
and execute the block each time a new commit appear in the branch

```ruby
consumer.consume do |message|
    puts message
end
```

You'll need to run it in another thread to prevent blocking your consumer if you
wish to do other work in the same process.

After your block finish execution the consumer will tag this commit with a git
tag, the tag name will be the branch name + `.` + your consumer name, if your
consumer name is `consumer1` and consuming from `master` branch, the tag will be
`master.consumer1`, that tag will be overritten each time the consumer process a
message.

# Pushing and Pulling your data

As for now there is no way to push/pull from the gem, so this part is up to you,
until it's implemented in the gem.
