
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

  s.frameworks = 'UIKit', 'Foundation'

  #ss.resource_bundle = { "Shortcut" => "APP_UtilityTool/Shortcut/Assets/**/*" }

  s.subspec 'Ads' do |ss|
    ss.dependency "Google-Mobile-Ads-SDK"
    ss.source_files  = "APP_UtilityTool/Ads/Classes/**/*"
  end

  s.subspec 'Shortcut' do |ss|
    ss.frameworks = 'Intents', 'IntentsUI'
    ss.source_files  = "APP_UtilityTool/Shortcut/Classes/**/*"
  end

  s.subspec 'IAP' do |ss|
    ss.frameworks = 'StoreKit'
    ss.source_files  = "APP_UtilityTool/IAP/Classes/**/*"
  end


end
