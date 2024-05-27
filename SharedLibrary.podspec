Pod::Spec.new do |spec|
  spec.name = "SharedLibrary"
  spec.version = "1.0.0"
  spec.summary = "First version of this library"
  spec.homepage = "https://github.com/MarwanAziz/kotlinMultiplatform" # Replace with your repo URL
  spec.license = "MIT" # Change if needed

  # Point to your Git repository for source
  spec.source = { :git => "https://github.com/MarwanAziz/kotlinMultiplatform.git", :tag => spec.version.to_s }

  spec.ios.deployment_target = "10.0" # Update minimum deployment target if needed

  spec.framework = "shared"
  spec.static_framework = true

  spec.requires_arc = true

  # Define the path to the Kotlin/Native framework
#   spec.vendored_frameworks = "build/bin/ios/releaseFramework/shared.framework"
end