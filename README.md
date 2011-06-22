# Overview

This gem provides a set of RSpec matchers to allow relative comparisons of images. 

e.g. User.image.should look_like(otherimage)

# Requirements

The gem has only been tested with Rails 3 and RSpec 2. 

It also relies on imagemagick being installed and available from the command line as it utilisies its 'identify' command. The Gem has only been tested with Imagemagick V6.x.

# Setup

Include the gem in your Gemfile:-

~~~~ { ruby }
gem 'image-spec'
~~~~

include the matchers in your spec_helper.rb:-

~~~~ { ruby }
require 'image_spec/matchers'
~~~~

#Usage

###look_like

Allows you to test that an image is within a 1% of the expected image e.g.

~~~~ { ruby }
actual.should look_like(expected)
~~~~

or 

~~~~ { ruby }
user.picture.path(:thumb).should look_like(fixtures('member_picture/thumb/test.png'))
~~~~

###have_image_that_looks_like

Test if a page contains an image that is like the stated image e.g.


