source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Pirates Of Tokyo Bay' do
    pod 'Alamofire', '~> 3.5'
    pod 'ReachabilitySwift', '~> 2.4'   
end

pod 'GoogleMaps', '1.10.5'

pod 'Spring', :git => 'https://github.com/tpae/Spring.git', :branch => 'swift-2.3-migration'

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        # Configure Pod targets for Xcode 8 compatibility
        config.build_settings['SWIFT_VERSION'] = '2.3'
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'Issan Zeibak'
        config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
    end
end
