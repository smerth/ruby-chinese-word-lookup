#### Word Finder ####
#
# Launch this Ruby file from the command line 
# to get started.
#

# This APP_ROOT variable stores the absolute path to this very file.
# so it is the basis of writing paths to files used in the application.
APP_ROOT = File.dirname(__FILE__)

# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'guide.rb')
# require File.join(APP_ROOT, 'lib', 'guide')

# "$" is a special variable in Ruby.  It contains the paths to directories
# Ruby is aware of a will look in find files it needs
# .unshift method appends to the beginning of this list of paths the path
# to a new directory we want Ruby to be aware of
$:.unshift( File.join(APP_ROOT, 'lib') )
require 'dictionary'

dictionary = Dictionary.new('dictionary.txt')
dictionary.launch!