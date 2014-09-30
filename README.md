# Overview

This gem provides a set of [RSpec](http://rspec.info) matchers to allow relative comparisons of images.

e.g. User.image.should look_like(otherimage)

# Requirements

The gem relies on [ImageMagick](http://www.imagemagick.org/) being installed and available from the command line as it utilizes its [`identify`](http://www.imagemagick.org/script/identify.php) command.

The gem has only been tested with Rails 3.0 & 3.1 with the asset pipeline and RSpec 2; it has also only been tested with ImageMagick V6.x.

# Setup

Include the gem in your Gemfile:

~~~~ { ruby }
gem 'image_spec'
~~~~

include the matchers in your spec_helper.rb:

~~~~ { ruby }
require 'image_spec/matchers'
~~~~

#Usage

###look_like

Allows you to test that an image is within a 1% of the expected image, e.g.:

~~~~ { ruby }
actual.should look_like(expected)
~~~~

or

~~~~ { ruby }
user.picture.path(:thumb).should look_like(fixtures('member_picture/thumb/test.png'))
~~~~

###have_image_that_looks_like

Test if a page contains an image that is like the stated image, e.g.:

~~~~ { ruby }
rendered.should have_image_that_looks_like(expected)
~~~~
