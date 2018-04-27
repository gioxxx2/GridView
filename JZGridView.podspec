

Pod::Spec.new do |s|

  s.name         = "JZGridView"
  s.version      = "0.1.0"
  s.summary      = "表格视图"
  s.description  = "可以支持不同方向滚动的表格视图"
  s.homepage     = "https://github.com/gioxxx2/GridView"
  s.license      = "MIT"
  s.author       = { "JZTech-xuz" => "617223701@qq.com" }
  s.source        = { :git => "https://github.com/gioxxx2/GridView.git", :tag => "#{s.version}" }
  s.source_files  = "JZGridView"
  s.dependency   'MJRefresh'
  s.dependency   'Masonry'
  s.ios.deployment_target = '9.0'
end
