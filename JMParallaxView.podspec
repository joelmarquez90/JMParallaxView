Pod::Spec.new do |s|
  s.name             = 'JMParallaxView'
  s.version          = '0.1.0'
  s.summary          = 'A drop-in solution for all your parallax problems'

  s.description      = <<-DESC
The idea of this pod is to serve as a simple solution when creating a view that has a parallax header
                       DESC

  s.homepage         = 'https://github.com/joelmarquez90/JMParallaxView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joel Marquez' => 'jmarquez@monits.com' }
  s.source           = { :git => 'https://github.com/joelmarquez90/JMParallaxView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/joelmarquez90'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JMParallaxView/Classes/**/*'

  s.dependency 'Masonry'
end
