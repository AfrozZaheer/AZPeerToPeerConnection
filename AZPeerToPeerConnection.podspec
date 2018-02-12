
Pod::Spec.new do |s|


  s.name         = "AZPeerToPeerConnection"
  s.version      = "0.1.0"
  s.summary      = "Automatic pagination handling and loading views"

  s.description  = <<-DESC
        Automatic pagination handling
        No more awkward empty TableView
    DESC

  s.homepage     = "https://AfrozNXB@bitbucket.org/AfrozNXB/privatepodtest.git"


  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  s.author       = { "AfrozZaheer" => "afrozezaheer@gmail.com" }

  s.source       = { :git => "." }
  s.platform     = :ios, "9.0"


 
  s.source_files = 'Source/**/*.{swift}'

end
