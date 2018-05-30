Pod::Spec.new do |s|
  s.name         = 'expanding-collection'
  s.version      = '2.1.0'
  s.summary      = 'Transition animtion from CollectionView to TableView'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/Ramotion/expanding-collection'
  s.author       = { 'Juri Vasylenko' => 'juri.v@ramotion.com' }
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/Ramotion/expanding-collection.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
end
