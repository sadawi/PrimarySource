Pod::Spec.new do |s|
  s.name             = "PrimarySource"
  s.version          = "0.1.0"
  s.summary          = "A short description of PrimarySource."

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/sadawi/PrimarySource"
  s.license          = 'MIT'
  s.author           = { "Sam Williams" => "samuel.williams@gmail.com" }
  s.source           = { :git => "https://github.com/sadawi/PrimarySource.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PrimarySource' => ['Pod/Assets/*']
  }
end
