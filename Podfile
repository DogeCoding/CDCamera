# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CDCamare' do
  	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!

  	# Pods for CDCamare
	pod 'IQKeyboardManagerSwift'
	pod 'Kingfisher'
	pod 'MJRefresh'
    pod 'SnapKit'
    pod 'MBProgressHUD'
    pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa', '~> 4.0'

	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    target.build_configurations.each do |config|
	      config.build_settings['ENABLE_BITCODE'] = 'NO'
	    end
	  end
	end

end

