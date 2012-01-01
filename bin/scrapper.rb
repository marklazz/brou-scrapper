#!/usr/bin/env ruby
# The command line Haml parser.
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'lib/brou'
Brou::Controller.scrape_and_notify!
