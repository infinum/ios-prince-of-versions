Pod::Spec.new do |s|
  s.name = "PrinceOfVersions"
  s.version = "1.0.0"
  s.summary = "Library checks for updates using configuration from some resource."
  s.homepage = "https://github.com/infinum/iOS-prince-of-versions"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Jasmin Abou Aldan" => "jasmin.aboualdan@infinum.hr" }
  s.platform = :ios, :osx
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source = { :git => "https://github.com/infinum/iOS-prince-of-versions.git", :tag => "#{s.version}" }
  s.source_files  = "Versioner/**/*.{h,m,swift}"
  s.swift_version = "5.0"
end
