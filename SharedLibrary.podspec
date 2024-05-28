Pod::Spec.new do |spec|
  spec.name = 'SharedLibrary'
  spec.version = '1.0.0'
  spec.homepage = 'https://www.cocoapods.org'
  spec.source = { :git => "https://github.com/MarwanAziz/kotlinMultiplatform.git", :tag => "1.0.0" }
  spec.authors = 'Marwan Aziz'
  spec.license = 'Private'
  spec.summary = 'An example project'
  spec.static_framework = true
  spec.vendored_frameworks = "SharedLibrary.framework"
  spec.libraries = "c++"
  spec.module_name = "#{spec.name}_umbrella"
  spec.ios.deployment_target = '16.0'
end