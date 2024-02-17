#!/bin/bash

# Run your background commands here
rails db:migrate
bundle exec racecar ElasticMessagesConsumer --daemonize &
bundle exec racecar MessagesConsumer --daemonize &
bundle exec racecar ChatsConsumer --daemonize &
# Add more commands as needed
