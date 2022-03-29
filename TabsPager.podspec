Pod::Spec.new do |spec|


  spec.name         = "TabsPager"
  spec.version      = "0.0.2"
  spec.summary      = "Quick setup pager with tabs"

  spec.description  = <<-DESC
setup pager with scrollable tabs
                   DESC

  spec.homepage     = "https://github.com/yuan356/TabsPager"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "will" => "willchen356@gmail.com" }

  spec.swift_version = "5"

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/yuan356/TabsPager.git", :tag => "#{spec.version}" }

  spec.source_files  = "TabsPager/**/*.{h,m,swift}"


  spec.dependency 'AnchorLayout', '~> 0.0.1'

end
