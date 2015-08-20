Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.11.0'
  s.license      =  {:type => 'BSD'}
  s.homepage     = 'https://github.com/pixnet/pixnet-ios-sdk'
  s.authors      =  {'PIXNET' => 'sdk@pixnet.tw'}
  s.summary      = 'Integrate with PIXNET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  {:git => 'https://github.com/pixnet/pixnet-ios-sdk.git', :tag => '1.11.1'}
  s.source_files =  'PIXNET-iOS-SDK/Classes/*.{h,m}', 'PIXNET-iOS-SDK/Classes/LROAuth2Client/*.{h,m}'
  s.framework    =  'CoreLocation'

  s.requires_arc = true
  #s.requires_arc = 'PIXNET-iOS-SDK/Classes/*.{h,m}'
  
# Pod Dependencies
  s.dependency 'cocoa-oauth', '~> 0.0.1'
  s.dependency 'OMGHTTPURLRQ', '~> 2.1'
end
