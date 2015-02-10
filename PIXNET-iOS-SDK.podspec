Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.5.0'
  s.license      =  {:type => 'BSD'}
  s.homepage     = 'http://developer.pixnet.pro/#!/doc/pixnetApi/oauthApi'
  s.authors      =  {'PIXNET' => 'sdk@pixnet.tw'}
  s.summary      = 'Integrate with PIXNET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  {:git => 'https://github.com/pixnet/pixnet-ios-sdk.git', :tag => '1.5.0'}
  s.source_files =  'PIXNET-iOS-SDK/Classes/*.{h,m}'
  s.framework    =  'CoreLocation'

  s.requires_arc = false
  
# Pod Dependencies
  s.dependency 'cocoa-oauth', '~> 0.0.1'
end
