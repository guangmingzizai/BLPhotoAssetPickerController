#
# Be sure to run `pod lib lint BLPhotoAssetPickerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLPhotoAssetPickerController'
  s.version          = '0.1.1'
  s.summary          = 'A image picker supports multiple selection.'
  s.description      = <<-DESC
  BLPhotoAssetPickerController can select multiple images from photo album, and support take camera. You can customize the selection photo num.
  It's design has many defects, but I have no time to refactor it.
  Since my work is so busy, I can't promise to maintain this library.
                       DESC

  s.homepage         = 'https://github.com/guangmingzizai/BLPhotoAssetPickerController'
  s.screenshots     = [
    'https://github.com/guangmingzizai/BLPhotoAssetPickerController/raw/master/Screenshots/BLPhotoAssetPickerController1t.png?raw=true',
    'https://github.com/guangmingzizai/BLPhotoAssetPickerController/raw/master/Screenshots/BLPhotoAssetPickerController2t.png?raw=true',
    'https://github.com/guangmingzizai/BLPhotoAssetPickerController/raw/master/Screenshots/BLPhotoAssetPickerController3t.png?raw=true',
    'https://github.com/guangmingzizai/BLPhotoAssetPickerController/raw/master/Screenshots/BLPhotoAssetPickerController4t.png?raw=true',
    'https://github.com/guangmingzizai/BLPhotoAssetPickerController/raw/master/Screenshots/BLPhotoAssetPickerController5t.png?raw=true',
  ]
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guangmingzizai' => 'guangmingzizai@qq.com' }
  s.source           = {
    :git => 'https://github.com/guangmingzizai/BLPhotoAssetPickerController.git',
    :tag => '0.1.1'
  }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BLPhotoAssetPickerController/Classes/**/*'

  s.resource_bundles = {
    'BLPhotoAssetPickerController' => ['BLPhotoAssetPickerController/Assets/*.png']
  }
  s.requires_arc = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'AssetsLibrary', 'QuartzCore'
    s.dependency 'MBProgressHUD'
    s.dependency 'MWPhotoBrowser@guangmingzizai', '~> 2.2.0'
    s.dependency 'Masonry'

end
