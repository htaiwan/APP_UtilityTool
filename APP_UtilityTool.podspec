
Pod::Spec.new do |s|
  s.name             = 'APP_UtilityTool'
  s.version          = '0.1.0'
  s.summary          = 'iOS APP Utility Tool.'

  s.description      = <<-DESC
This is an utility tool for developing iOS app.
                       DESC

  s.homepage         = 'https://github.com/htaiwan/APP_UtilityTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cheng, Chien-Tai' => 'htaiwan@gmail.com' }
  s.source           = { :git => 'https://github.com/htaiwan/APP_UtilityTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.2'
  s.static_framework = true

  #s.source_files = 'APP_UtilityTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'APP_UtilityTool' => ['APP_UtilityTool/Assets/*.png']
  # }
  s.frameworks = 'UIKit', 'Foundation'

  s.subspec 'Ads' do |ss|
    ss.dependency "Google-Mobile-Ads-SDK"
    ss.source_files  = "APP_UtilityTool/Ads/Classes/**/*"
    ss.resource_bundle = { "Ads" => "APP_UtilityTool/Ads/Assets/**/*" }
  end

  s.subspec 'Shortcut' do |ss|
    ss.source_files  = "APP_UtilityTool/Shortcut/Classes/**/*"
    ss.resource_bundle = { "Shortcut" => "APP_UtilityTool/Shortcut/Assets/**/*" }
  end

  s.subspec 'IAP' do |ss|
    ss.source_files  = "APP_UtilityTool/IAP/Classes/**/*"
    ss.resource_bundle = { "IAP" => "APP_UtilityTool/IAP/Assets/**/*" }
  end


end
