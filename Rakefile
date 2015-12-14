# Slight adjustment from this source:
# http://sourcey.com/middleman-automated-github-pages-deployments-with-rake

GH_USER = 'rpbaptist'
GIT_MAIL = 'rpbaptist@gmail.com'

desc 'build static pages'
task :build do
  puts '## Compiling static pages'
  system 'bundle exec middleman build'
end

desc 'deploy to github pages'
task :deploy do
  puts '## Deploying to Github Pages'
  cd 'build' do
    system 'git init'
    system "git remote add origin git@github.com:#{GH_USER}/#{GH_USER}.github.io.git"
    system 'git add --all'
    message = "Site updated at #{Time.now.utc}"
    puts "## Commiting: #{message}"
    system "git config user.email #{GIT_MAIL}"
    system "git commit -m \"#{message}\""
    puts '## Pushing generated website'
    system 'git push origin +master'
    puts '## Github Pages deploy complete'
  end
end

desc 'build and deploy to github pages'
task :publish do
  Rake::Task['build'].invoke
  Rake::Task['deploy'].invoke
end
