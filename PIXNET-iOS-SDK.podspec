Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.13.3'
  s.license      =  {:type => 'BSD'}
  s.homepage     = 'https://github.com/pixnet/pixnet-ios-sdk'
  s.authors      =  {'PIXNET' => 'sdk@pixnet.tw'}
  s.summary      = 'Integrate with PIXNET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  {:git => 'https://github.com/pixnet/pixnet-ios-sdk.git', :tag => '1.13.3'}
  s.source_files =  'PIXNET-iOS-SDK/Classes/*.{h,m}', 'PIXNET-iOS-SDK/Classes/LROAuth2Client/*.{h,m}'
  s.framework    =  'CoreLocation'
  s.resource_bundles = { 'PIXNET-iOS-SDK' => 'PIXNET-iOS-SDK/LocalizableStrings/**' }
  s.requires_arc = true
  
# Pod Dependencies
  s.dependency 'PIX-cocoa-oauth', '~> 0.0.1'
  s.dependency 'OMGHTTPURLRQ', '~> 3.0.2'
end
