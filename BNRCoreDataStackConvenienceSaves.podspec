#
# Be sure to run `pod lib lint BNRCoreDataStackConvenienceSaves.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BNRCoreDataStackConvenienceSaves"
  s.version          = "0.1.0"
  s.summary          = "BNRCoreDataStack ConvenienceSaves Add On"
  s.description      = <<-DESC
                        BNRCoreDataStackConvenienceSaves is an Add On to the BNRCoreDataStack library. 
                        It adds several methods to the CoreDataModelable protocol that makes saving 
                        context easier.
                       DESC

  s.homepage         = "https://github.com/darrarski/BNRCoreDataStackConvenienceSaves"
  s.license          = 'MIT'
  s.author           = { "Dariusz Rybicki" => "darrarski@gmail.com" }
  s.source           = { :git => "https://github.com/darrarski/BNRCoreDataStackConvenienceSaves.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/darrarski'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BNRCoreDataStackConvenienceSaves/**/*'
  
  s.dependency 'BNRCoreDataStack', '~> 1.2'
end
