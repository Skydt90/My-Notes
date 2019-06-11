# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'My Notes' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for My Notes

pod 'SwipeCellKit'
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
