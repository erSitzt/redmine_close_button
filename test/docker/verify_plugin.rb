# Smoke test for redmine_close_button, executed inside an official Redmine
# Docker image via `rails runner`.
#
# It verifies that:
#   * the plugin is registered with the version from the VERSION file,
#   * an issue page renders the close button link and the plugin assets.
#
# See test/docker/run.sh for how this script is invoked.

PASSWORD = 'DockerSmokeTest#12345'.freeze
PROJECT_IDENTIFIER = 'close-button-test'.freeze

def assert(condition, message)
  raise message unless condition
end

expected_version = File.read(
  File.join(Rails.root, 'plugins', 'redmine_close_button', 'VERSION')
).strip

plugin = Redmine::Plugin.find(:redmine_close_button)
assert plugin.version == expected_version,
       "plugin version #{plugin.version.inspect} does not match VERSION file #{expected_version.inspect}"
puts "Plugin registered: #{plugin.id} #{plugin.version}"

Redmine::DefaultData::Loader.load('en') if Redmine::DefaultData::Loader.no_data?

user = User.find_by_login('admin')
assert user, 'admin user not found'
user.password = PASSWORD
user.must_change_passwd = false
user.admin = true
user.save!

project = Project.find_by_identifier(PROJECT_IDENTIFIER) ||
          Project.create!(:name => 'Close Button Test', :identifier => PROJECT_IDENTIFIER)
project.enabled_module_names = ['issue_tracking']
project.trackers = Tracker.all
project.save!

issue = Issue.where(:project_id => project.id).first
issue ||= Issue.create!(:project => project,
                        :tracker => Tracker.first,
                        :subject => 'Close button smoke test',
                        :author => user,
                        :status => IssueStatus.where(:is_closed => false).first,
                        :priority => IssuePriority.first)

session = ActionDispatch::Integration::Session.new(Rails.application)
session.get '/login'
assert session.response.status == 200, "login page returned #{session.response.status}"

token = session.response.body[/name="authenticity_token"[^>]*value="([^"]+)"/, 1] ||
        session.response.body[/value="([^"]+)"[^>]*name="authenticity_token"/, 1]
assert token, 'could not extract authenticity token from login page'

session.post '/login', :params => { :username => user.login,
                                    :password => PASSWORD,
                                    :authenticity_token => token }
session.follow_redirect! if session.response.redirect?

session.get "/issues/#{issue.id}"
assert session.response.status == 200, "issue page returned #{session.response.status}"

body = session.response.body
assert body.include?('redmine-close-button'), 'close button link is missing on the issue page'
# Redmine 6+ serves plugin assets through the asset pipeline, so file names are digested.
assert body =~ %r{redmine_close_button[-\w]*\.js}, 'plugin javascript is missing on the issue page'
assert body =~ %r{redmine_close_button[-\w]*\.css}, 'plugin stylesheet is missing on the issue page'

puts "Close button rendered on /issues/#{issue.id}"
puts 'OK'
