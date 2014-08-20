//
//  YJZAlbumCollectionViewLayout.h
//  YJZAlbumCollectionView
//
//  Created by YU JOHNNY ZHOU on 18/08/2014.
//  Copyright (c) 2014 YU JOHNNY ZHOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJZAlbumCollectionViewDelegate <UICollectionViewDelegate>

@optional
- (UIEdgeInsets) insetsForItemAtIndexPath: (NSIndexPath *)indexPath;//default : uiedginsetszero

@end

@interface YJZAlbumCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) UICollectionViewScrollDirection direction; //default : UICollectionViewScrollDirectionVertical
@property (nonatomic, assign) CGSize blockSize; //default : CGSize(100.0f, 100.0f)
@property (nonatomic, assign) CGFloat rowHeight; //default : 100.f

@property (nonatomic, weak) IBOutlet NSObject<YJZAlbumCollectionViewDelegate>* delegate;

- (BOOL) addLayout:(NSDictionary *)rowLayout;

@end
