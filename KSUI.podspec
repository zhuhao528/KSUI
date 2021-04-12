#
# Be sure to run `pod lib lint KSUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSUI'
  s.version          = '2.0.0.16'
  # 1.2.3.4         4 修修改改 3 新加样式 减少样式 组件级别 2 重大改版 弃用方法 增加方法 1 UI UI设计版本
  s.summary          = 'A short description of KSUI. 2021.01.29.11.26'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  2.0.0.1 增加基础按钮
  2.0.0.2 添加渐变按钮
  2.0.0.3 添加KSTextField和KSView
  2.0.0.4 添加kSPopover
  2.0.0.5 添加KSImageView
  2.0.0.6 添加图片圆角的方法
  2.0.0.7 简化KSButton
  2.0.0.8 删除KSAttributeButton 将垂直居中的方法放到分类中 防止多继承的问题
  2.0.0.9 kSPopover添加KSPopoverTypeLeft，KSPopoverTypeRight，KSPopoverTypeAuto等类型
  2.0.0.10 添加KSLabel
  2.0.0.11 修改气泡弹窗
  2.0.0.12 分类滑动视图KSPageView、弹窗KSActionSheet、播放器进度条KSSliderView、UKSHudView弹窗管理、UKSHudViewController视图控制器弹窗、UKSPickerView、KSVisualizedIPView形象、UKSHUD提示、KSStoryActionSheet底部弹窗、UKSAlertView自定义弹窗，KSCircleProgressView进度条, 动态计算toast时长,无动画适配
  2.0.0.13 封装通用水平方向列表actionSheet,移除commonDefines引用
  2.0.0.14 pageView添加滚动结束当前的index的回调
  2.0.0.15 播放器进度条添加自定义视图
  2.0.0.16 水平方向列表actionSheet支持更新图片、文字的方法；获取下标图片对象的方法；水平方向列表actionSheet新增初始化方法，获取不到图片优化，增加显示完成回调
  
  DESC

  s.homepage         = 'http://gitlab.devops.kaishustory.com/ios/KSUI.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuhao' => 'zhuhao@ksjgs.com' }
  s.source           = { :git => 'http://gitlab.devops.kaishustory.com/ios/KSUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # 逐步取消。。。
  s.source_files = 'KSUI/Classes/Other/**/*'
  
  # 添加swift版本
  s.swift_version = '5.0'
  
  # 静态库
  #s.static_framework = true
  
  #  s.source_files = 'KSUI/Classes/**/*'

  # 图片资源
   s.resource_bundles = {
     'KSUI' => ['KSUI/Assets/*.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  #子库
  # KSPageView 分类滑动视图
  s.subspec 'KSPageView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/KSPageView/**/*.{h,m}'
      ss.public_header_files = 'KSUI/Classes/KSUIComponents/KSPageView/**/*.h'
  end
  # UKSSliderView 播放器进度条
  s.subspec 'UKSSliderView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSSliderView/**/*.{h,m}'
      ss.public_header_files = 'KSUI/Classes/KSUIComponents/UKSSliderView/**/*.h'
  end
  
  # UKSSliderView 播放器进度条
  s.subspec 'UKSSliderView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSSliderView/**/*.{h,m}'
      ss.public_header_files = 'KSUI/Classes/KSUIComponents/UKSSliderView/**/*.h'
  end

  # UKSHudView 视图弹窗
  s.subspec 'UKSHudView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSHudView/**/*.swift'
      ss.dependency 'KSRouterHelpToolModule' # 获取top视图控制器
  end
  # UKSHudViewController 视图控制器弹窗
  s.subspec 'UKSHudViewController' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSHudViewController/**/*.swift'
      ss.dependency 'KSRouterHelpToolModule' # 获取top视图控制器
  end
  # UKSPickerView 弹窗选择器
  s.subspec 'UKSPickerView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSPickerView/**/*.swift'
      ss.dependency 'SnapKit'
  end
  # KSVisualizedIPView IP形象
  s.subspec 'KSVisualizedIPView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/KSVisualizedIPView/**/*.swift'
#      ss.dependency 'KSAudioPlayerModule' 
  end
  # KSHUD 提示
  s.subspec 'UKSHUD' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSHUD/**/*.swift'
      ss.dependency 'PKHUD', '~> 5.3.0'
  end
  # UKSToast 提示
  s.subspec 'UKSToast' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSToast/**/*.swift'
      ss.dependency 'Toast-Swift'
  end
  # 通用样式弹窗
  s.subspec 'UKSAlertView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSAlertView/**/*.swift'
  end
  # 进度条
  s.subspec 'KSCircleProgressView' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/KSCircleProgressView/**/*.swift'
  end
  # KSActionSheet 列表弹窗
  s.subspec 'KSActionSheet' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/KSActionSheet/**/*.{h,m}'
      ss.public_header_files = 'KSUI/Classes/KSUIComponents/KSActionSheet/**/*.h'
      ss.dependency 'Masonry'
  end
  # UKSFlowLayout 自定义布局
  s.subspec 'UKSFlowLayout' do |ss|
      ss.source_files = 'KSUI/Classes/KSUIComponents/UKSFlowLayout/**/*.swift'
  end
  
end
