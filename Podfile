platform :ios, '13.0'
inhibit_all_warnings!

target 'MyGithub' do

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources', '~> 4.0'
  pod 'Alamofire', '~> 5.0.0-rc.3'

  target 'MyGithubTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end
