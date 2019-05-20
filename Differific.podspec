Pod::Spec.new do |s|
  s.name             = "Differific"
  s.summary          = "A fast and convenient diffing framework"
  s.version          = "0.8.0"
  s.homepage         = "https://github.com/zenangst/Differific"
  s.license          = 'MIT'
  s.author           = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.source           = {
    :git => "https://github.com/zenangst/Differific.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/zenangst'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.ios.source_files = 'Source/{iOS+tvOS,Shared}/**/*'
  s.tvos.source_files = 'Source/{iOS+tvOS,Shared}/**/*'
  s.osx.source_files = 'Source/{macOS,Shared}/**/*'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
end
