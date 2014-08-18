Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.1.1'
  s.license      =  {:type => 'BSD'}
  s.homepage     = 'http://developer.pixnet.pro/#!/doc/pixnetApi/oauthApi'
  s.authors      =  {'Cloud Sung' => 'cloud@pixnet.tw', 'Dolphin Su'=>'dolphinsu@pixnet.tw'}
  s.summary      = 'Intergration with PIXNET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  {:git => 'https://github.com/pixnet/pixnet-ios-sdk.git', :tag => '1.1.1'}
  s.source_files =  'PIXNET-iOS-SDK/Classes/*.{h,m}'
  s.framework    =  'CoreLocation'

  s.requires_arc = false
  
# Pod Dependencies
  s.dependency 'cocoa-oauth', '~> 0.0.1'
end
