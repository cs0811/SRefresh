

Pod::Spec.new do |s|



  s.name         = "SRefresh"
  s.version      = "0.1.0"
  s.summary      = "this a refreshController."

  s.description  = <<-DESC
*	模仿淘宝刷新，滚动到局里底部一定距离后，自动加载更多
                   DESC

  s.homepage     = "https://github.com/cs0811/SRefresh"
 


 
  s.license      = "MIT"


 
  s.author             = { "cs0811" => "382766636@qq.com" }
  
  s.platform     = :ios, "7.0"



 
  s.source       = { :git => "https://github.com/cs0811/SRefresh.git", :tag => "0.1.0" }


   s.source_files  =  "Classes/*.{h,m}"



  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"



 
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # s.requires_arc = true

   s.dependency "Masonry", "~> 0.6.3"

end
