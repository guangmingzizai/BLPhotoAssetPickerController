#
# Be sure to run `pod lib lint BLPhotoAssetPickerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLPhotoAssetPickerController'
  s.version          = '0.1.4'
  s.summary          = 'A image picker supports multiple selection.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/guangmingzizai/BLPhotoAssetPickerController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guangmingzizai' => 'guangmingzizai@qq.com' }
  s.source           = { :git => 'https://github.com/guangmingzizai/BLPhotoAssetPickerController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BLPhotoAssetPickerController/Classes/**/*'

  s.resource_bundles = {
    'BLPhotoAssetPickerController' => ['BLPhotoAssetPickerController/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'AssetsLibrary', 'QuartzCore'
    s.dependency 'MBProgressHUD'
    s.dependency 'MWPhotoBrowser@guangmingzizai', '~> 2.2.2'
    s.dependency 'Masonry'

end
