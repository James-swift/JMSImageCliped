Pod::Spec.new do |s|

  s.name          = "JMSImageCliped"
  s.version       = "1.0.0"
  s.license       = "MIT"
  s.summary       = "The Swift version of UIView and UIImageView draw the rounded corners."
  s.homepage      = "https://github.com/James-swift/JMSImageCliped"
  s.author        = { "xiaobs" => "1007785739@qq.com" }
  s.source        = { :git => "https://github.com/James-swift/JMSImageCliped.git", :tag => "1.0.0" }
  s.requires_arc  = true
  s.description   = <<-DESC
                   JMSImageCliped - The Swift version of UIView and UIImageView draw the rounded corners.
                   DESC
  s.source_files  = "JMSImageCliped/Lib/*"
  s.platform      = :ios, '8.0'
  s.framework     = 'Foundation', 'UIKit'  

end
