source 'https://rubygems.org'

gem "rake"
gem "serverspec", '~> 2.20'
gem "specinfra", '~> 2.40'
gem "activesupport", '~> 4'
gem "docker-api"
gem "colorize"
gem "parseconfig"
gem "rspec_junit_formatter", github: 'gooddata/rspec_junit_formatter',
                             branch: 'yut-qa-5784'
gem 'rubocop', '~> 0.37'
gem 'rubocop-junit-formatter', github: 'gooddata/rubocop-junit-formatter'

group :cista do
  gem 'jira-ruby', require: 'jira'
  gem 'confluence-client'
  gem 'rest-client'
end

group :development do
  gem 'pry'
end
