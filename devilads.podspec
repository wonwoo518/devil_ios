Pod::Spec.new do |s|
  s.name             = 'devilads'
  s.platform         = :ios
  s.version          = '0.0.164'
  s.summary          = 'Devil Ads'
  s.description      = <<-DESC
    This is Devil Ads
                       DESC
  s.homepage         = 'https://github.com/muyoungko/devil_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'muyoungko' => 'muyoungko@gmail.com' }
  s.source           = { :git => 'https://github.com/muyoungko/devil_ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.3'
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}"'
  }
  
  s.source_files = 'devilads/devilads/source/**/*.*', 'devilads/devilads/header/**/*.h'
  s.public_header_files = 'devilads/devilads/source/**/*.h', '"${DERIVED_SOURCES_DIR}/*-Swift.h'
  s.dependency 'devilcore', '~> 0.0.94'
  # s.depondency 'Google-Mobile-Ads-SDK'
  # s.resources = 'devilads/devilads/resource/*'

end
