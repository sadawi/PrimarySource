Pod::Spec.new do |s|
  s.name             = "PrimarySource"
  s.version          = "2.0.2"
  s.summary          = "Collection data sources"
  s.homepage         = "https://github.com/sadawi/PrimarySource"
  s.license          = 'MIT'
  s.author           = { "Sam Williams" => "samuel.williams@gmail.com" }
  s.source           = { :git => "https://github.com/sadawi/PrimarySource.git", :tag => s.version.to_s }

  s.source_files = 'Pod/shared/**/*.{swift}'

  s.ios.source_files = 'Pod/iOS/**/*.{swift}'
  s.ios.deployment_target = '9.0'

  s.osx.source_files = 'Pod/OSX/**/*.{swift}'
  s.osx.deployment_target = '10.11'

end
