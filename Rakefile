require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ldacats"
    gem.summary = %Q{A one-off tool for extracting categories from GibbsLDA++ output}
    gem.description = %Q{Convert the output of GibbsLDA++ (*.phi, specifically) into a YAMLized category mapping suitable for evaluation with clusterval}
    gem.email = "doches@gmail.com"
    gem.homepage = "http://github.com/doches/ldacats"
    gem.authors = ["Trevor Fountain"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ldacats #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
