spec.name = "SharedLibrary"
spec.version = "1.0.0" # Update version for each release
spec.summary = "First version of this library"
spec.homepage = "https://github.com/MarwanAziz/kotlinMultiplatform" # Replace with your repo URL (optional)
spec.license = "MIT" # Change if needed

# (Optional) Point to your Git repository for source (if using a remote repository)
# spec.source = { :git => "https://github.com/<your_github_username>/<library_name>.git", :tag => spec.version.to_s }

spec.ios.deployment_target = "10.0" # Update minimum deployment target if needed

spec.framework = "shared"
spec.static = true

spec.requires_arc = true