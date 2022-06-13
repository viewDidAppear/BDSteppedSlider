Pod::Spec.new do |s|
  s.name     = 'BDSteppedSlider'
  s.version  = '2.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A classic-style slider, with value snap and haptic feedback.'
  s.homepage = 'https://github.com/viewDidAppear/BDSteppedSlider'
  s.author   = 'Benjamin Deckys'
  s.source   = { :git => 'https://github.com/viewDidAppear/BDSteppedSlider.git', :tag => s.version }
  s.source_files = 'Classes/*{.swift}'
  s.swift_versions = [5.0]
  s.platform = :ios, '10.0'
  s.resources = "Resources/*{.png}"
end
