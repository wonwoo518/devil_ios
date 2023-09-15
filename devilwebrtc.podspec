Pod::Spec.new do |s|
  s.name             = 'devilbill'
  s.platform         = :ios
  s.version          = '0.0.250'
  s.summary          = 'Devil Bill'
  s.description      = <<-DESC
    This is Devil Login
                       DESC
  s.homepage         = 'https://github.com/muyoungko/devil_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'muyoungko' => 'muyoungko@gmail.com' }
  s.source           = { :git => 'https://github.com/muyoungko/devil_ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.3'
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}"'
  }
  
  s.source_files = 'devilbill/devilbill/source/**/*.*', 'devilbill/devilbill/header/**/*.h'
  s.public_header_files = 'devilbill/devilbill/source/**/*.h', '"${DERIVED_SOURCES_DIR}/*-Swift.h'
  s.static_framework = true
  s.dependency 'devilcore', '~> 0.0.250'
   
end