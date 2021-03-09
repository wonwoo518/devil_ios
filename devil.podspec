Pod::Spec.new do |s|
  s.name             = 'devil'
  s.platform         = :ios
  s.version          = '0.0.42'
  s.summary          = 'Devil Core'
  s.description      = <<-DESC
    This is Devil Core
                       DESC
  s.homepage         = 'https://github.com/muyoungko/devil_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'muyoungko' => 'muyoungko@gmail.com' }
  s.source           = { :git => 'https://github.com/muyoungko/devil_ios.git', :tag => s.version.to_s }
  #s.ios.deployment_target = '8.0'
  s.source_files = 'devilcore/devilcore/source/*.*', 'devilcore/devilcore/source/wildcard/*.*', 'devilcore/devilcore/source/wildcard/extensionview/*.*', 'devilcore/devilcore/source/wildcard/replacerule/*.*', 'devilcore/devilcore/source/wildcard/TriggerAction/*.*', 'devilcore/devilcore/source/wildcard/view/*.*'
  
  s.subspec 'DevilCore' do |devilCore|
    #devilCore.dependency 'lottie-ios', '~> 2.5.3'
    devilCore.source_files = 'devilcore/devilcore/source/*.*', 'devilcore/devilcore/source/wildcard/*.*', 'devilcore/devilcore/source/wildcard/extensionview/*.*', 'devilcore/devilcore/source/wildcard/replacerule/*.*', 'devilcore/devilcore/source/wildcard/TriggerAction/*.*', 'devilcore/devilcore/source/wildcard/view/*.*' , 'devilcore/devilcore/source/devil/core/*.*' , 'devilcore/devilcore/source/devil/core/javascript/*.*', 'devilcore/devilcore/source/devil/core/debug/*.*', 'devilcore/devilcore/source/devil/core/view/*.*', 'devilcore/lottie-ios/Classes/**/*.*', 'devilcore/devilcore/source/devil/core/wifi/*.*'
    devilCore.resources = 'devilcore/devilcore/source/resource/*'
  end

  s.subspec 'DevilLogin' do |devilLogin|
    devilLogin.dependency 'devil/DevilCore'
    devilLogin.source_files = 'devillogin/devillogin/source/*.*'
  end

end
