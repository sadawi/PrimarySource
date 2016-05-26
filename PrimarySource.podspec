Pod::Spec.new do |s|
  s.name             = "PrimarySource"
  s.version          = "0.9.11"
  s.summary          = "Collection data sources"
  s.homepage         = "https://github.com/sadawi/PrimarySource"
  s.license          = 'MIT'
  s.author           = { "Sam Williams" => "samuel.williams@gmail.com" }
  s.source           = { :git => "https://github.com/sadawi/PrimarySource.git", :tag => s.version.to_s }

  s.platforms        = { :ios => '9.0', :osx => '10.7' }
  s.requires_arc = true

  s.source_files = 'Pod/shared/**/*'
  s.osx.source_files = 'Pod/OSX/**/*'
  s.ios.source_files = 'Pod/iOS/**/*'

  s.osx.resource_bundles = {
    'PrimarySource' => ['Pod/shared/Assets/*']
  }

  s.ios.resource_bundles = {
    'PrimarySource' => ['Pod/shared/Assets/*']
  }

end
