Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.0'
  s.license      =  :type => 'BSD'
  s.homepage     = 'http://developer.pixnet.pro/#!/doc/pixnetApi/oauthApi'
  s.authors      =  {'Cloud Sung' => 'cloud@pixnet.tw', 'Dolphin Su'=>'dolphinsu@pixnet.tw'}
  s.summary      = 'Intergratied with PINET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  :git => 'https://github.com/pixnet/pixnet-ios-sdk', :tag => '1.0'
  s.source_files =  'Classes/*.{h,m}'
  s.framework    =  'CoreLocation'

  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'cocoa-oauth', '~> 0.0.1'
  s.dependencies =	pod 'RPJSONValidator', '~> 0.1.2'

end