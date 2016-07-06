Pod::Spec.new do |s|
  s.name         = 'CNBasicTools-OC'
  s.version      = '1.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = 'https://github.com/congni/CNBasicTools-OC.git'
  s.authors      = { "葱泥" => "983818495@qq.com" }
  s.summary      = 'OC开发基本工具库'
  s.description      = <<-DESC
                      A longer description of U in Markdown format.

                      * OC开发基本工具库
                      * pod使用方法: pod "CNBasicTools-OC"
                      * Try to keep it short, snappy and to the point.
                      * Finally, don't worry about the indent, CocoaPods strips it!
                      DESC

  s.ios.deployment_target = '7.0'
  s.source       =  { :git => "https://github.com/congni/CNBasicTools-OC.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'CNBasicTools-OC/*'

  s.dependency 'CNKit'
end