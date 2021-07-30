#!/bin/bash

gem install bundler
bundle install
#bundle exec kitchen converge
#bundle exec kitchen verify


bundle exec kitchen test
