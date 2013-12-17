$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'rspec/core'
require 'vagrant-omnibus'

RSpec.configure do |config|
  config.formatter = :documentation

  # a little syntactic sugar
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'

  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # run the examples in random order
  config.order = :rand

  # specify metadata with symobls only (ie no '=> true' required)
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
