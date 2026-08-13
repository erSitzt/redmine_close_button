require 'redmine'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require_dependency 'redmine_close_button/hooks'

# The VERSION file is the single source of truth for the plugin version.
REDMINE_CLOSE_BUTTON_VERSION = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

Redmine::Plugin.register :redmine_close_button do
  name 'Redmine Close Issue Button Plugin'
  author 'Undev'
  description 'This plugins enables you to close issues quickly using the Close Issue button.'
  version REDMINE_CLOSE_BUTTON_VERSION
  url 'http://github.com/Undev/redmine_close_button' if respond_to?(:url)
  author_url 'http://github.com/Undev'
  requires_redmine :version_or_higher => '0.9.0'
end
