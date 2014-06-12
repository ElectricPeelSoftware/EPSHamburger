Pod::Spec.new do |s|
  s.name             = "EPSHamburger"
  s.version          = "0.1.1"
  s.homepage         = "https://github.com/ElectricPeelSoftware/EPSHamburger"
  s.license          = "MIT"
  s.author           = { "Peter Stuart" => "peter@electricpeelsoftware.com" }
  s.source           = { :git => "https://github.com/ElectricPeelSoftware/EPSHamburger.git", :tag => s.version.to_s }
  
  s.platform              = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc          = true

  s.source_files = 'Classes'
  s.resources = "Resources/*.*"
  s.public_header_files = 'Classes/*.h'
end
