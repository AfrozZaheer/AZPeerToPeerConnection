
Pod::Spec.new do |s|


  s.name         = "AZPeerToPeerConnection"
  s.version      = "0.1.1"
  s.summary      = "Wrapper on top of Apple iOS Multipeer Connectivity framework"

  s.description  = <<-DESC
        AZPeerToPeerConnectivity is a wrapper on top of Apple iOS Multipeer Connectivity framework. It provides an easier way to create and manage sessions. Easy to integrate
    DESC

  s.homepage     = "https://github.com/AfrozZaheer/AZPeerToPeerConnection"


  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  s.author       = { "AfrozZaheer" => "afrozezaheer@gmail.com" }

  s.source       = { :git => "https://github.com/AfrozZaheer/AZPeerToPeerConnection.git" }
  s.platform     = :ios, "10.0"


 
  s.source_files = 'Source/**/*.{swift}'

end
