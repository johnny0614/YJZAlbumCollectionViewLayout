Pod::Spec.new do |s|
  s.name     = 'YJZAlbumCollectionViewLayout'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'YJZAlbumCollectionViewLayout is a subclass of UICollectionViewLayout that positions various sized cells like a maison laying bricks.'
  s.homepage = 'https://github.com/johnny0614/YJZAlbumCollectionViewLayout'
  s.author   = { 'YU JOHNNY ZHOU' => 'johnny0614@gmail.com' }
  s.source   = { :git => 'https://github.com/johnny0614/YJZAlbumCollectionViewLayout.git', :tag => '1.0.0' }
  s.description = 'YJZAlbumCollectionViewLayout is a UICollectionViewLayout subclass, used as the layout object of UICollectionView.

The idea of YJZAlbumCollectionViewLayout is inspired by RFQuiltLayout. The purpose of it is to allow users to create their desired collection layouts simply and straightforward.'
  s.source_files = 'YJZAlbumCollectionViewLayout'
  s.platform = :ios, '6.0'
  s.requires_arc = true
end