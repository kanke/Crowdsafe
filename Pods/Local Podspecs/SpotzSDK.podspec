Pod::Spec.new do |s|
	s.name	= 'SpotzSDK'
	s.platform = :ios,'6.0'
	s.license = 'Commercial License'
	s.version = '2.0.0.1'
	s.summary = 'SpotzSDK'
	s.homepage = 'http://www.localz.co'
	s.author = { 'Melvin Artemas' => 'ma@localz.co' }
	s.requires_arc = true
	s.ios.deployment_target = '6.0'
	s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited)' }
	s.preserve_paths = 'SpotzSDK.framework'
 	s.vendored_frameworks = 'SpotzSDK.framework'
	s.frameworks = 'CoreLocation'
	s.dependency 'Realm','0.87.4'
	s.dependency 'AFNetworking/NSURLConnection','>= 2.3.0'
	s.dependency 'AFNetworking/NSURLSession','>= 2.3.0'
end
