Pod::Spec.new do |s|
  s.name         = 'PIXNET-iOS-SDK'
  s.version      = '1.13.24'
  s.license      =  {:type => 'BSD'}
  s.homepage     = 'https://github.com/pixnet/pixnet-ios-sdk'
  s.authors      =  {'PIXNET' => 'sdk@pixnet.tw'}
  s.summary      = 'Integrate with PIXNET services.'

# Source Info
  s.platform     =  :ios, '6.0'
  s.source       =  {:git => 'https://github.com/pixnet/pixnet-ios-sdk.git', :tag => "#{s.version}"}
  s.source_files =  '../Classes/*.{h,m}', '../Classes/LROAuth2Client/*.{h,m}'
  s.framework    =  'CoreLocation','SystemConfiguration'
  s.resource_bundles = { 'PIXNET-iOS-SDK' => 'LocalizableStrings/**' }
  s.requires_arc = true
  
# Pod Dependencies
  s.dependency 'PIX-cocoa-oauth', '~> 0.0.2'
  s.dependency 'OMGHTTPURLRQ', '~> 3.0.2'
end
