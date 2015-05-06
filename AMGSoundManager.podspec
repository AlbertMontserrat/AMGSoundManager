#
# Be sure to run `pod lib lint AMGSoundManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AMGSoundManager"
  s.version          = "1.0"
  s.summary          = "Awesome sound manager singleton for Objective C"
  s.description      = <<-DESC
AMGSoundManager makes it simple the control of multiple sounds, loop sounds, change volume while playing, etc. All you need to do with sounds, can be done with AMGSoundManager with only one line of code.
                       DESC
  s.homepage         = "https://github.com/AlbertMontserrat/AMGSoundManager"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Albert Montserrat" => "albert.montserrat.gambus@gmail.com" }
  s.source           = { :git => "https://github.com/AlbertMontserrat/AMGSoundManager.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'AMGSoundManager' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
