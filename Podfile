# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'KitchenLogs' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    
    #pod 'SJSegmentedScrollView','1.3.6'
    pod 'AlamofireObjectMapper', '~> 4.0'
    pod 'SwiftyJSON'
#    pod 'RealmSwift'
    pod 'DropDown'
#    pod 'Fabric'
#    pod 'Crashlytics'
#    pod 'ReachabilitySwift', '~> 2.4'
    pod 'Firebase/Core'
    
end
    
    
    target 'KitchenLogsTests' do
        inherit! :search_paths
        # Pods for testing
        
    end
    
    target 'KitchenLogsUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
