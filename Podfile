# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NCCAA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'IQKeyboardManagerSwift'
pod 'SVProgressHUD'
pod 'SVGKit'
pod 'AlamofireObjectMapper', '~> 5.2'
pod 'SDWebImage', '~> 5.0'
pod 'MarqueeLabel'
pod 'SkyFloatingLabelTextField'

  # Pods for NCCAA
  post_install do |installer|
        installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
          end
        end
      end
end
