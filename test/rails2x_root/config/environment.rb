# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')



class TestGemLocator < Rails::Plugin::Locator
  def plugins
    Rails::Plugin.new(File.join(File.dirname(__FILE__), *%w(.. .. ..)))
  end
end



Rails::Initializer.run do |config|

  config.logger = nil

  config.plugin_locators << TestGemLocator

  config.frameworks -= [ :active_resource, :action_mailer ]

  config.time_zone = 'UTC'

end
