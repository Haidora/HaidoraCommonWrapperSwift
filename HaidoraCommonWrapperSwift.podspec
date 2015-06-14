Pod::Spec.new do |s|
  s.name             = "HaidoraCommonWrapperSwift"
  s.version          = "0.1.1"
  s.summary          = "常用代码"
  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/Haidora/HaidoraCommonWrapperSwift"
  s.license          = 'MIT'
  s.author           = { "mrdaios" => "mrdaios@gmail.com" }
  s.source           = { :git => "https://github.com/Haidora/HaidoraCommonWrapperSwift.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Assets/*.*'
  s.frameworks = 'UIKit', 'Foundation'
end
