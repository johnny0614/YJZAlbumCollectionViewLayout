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

@property (nonatomic, weak) IBOutlet NSObject<YJZAlbumCollectionViewDelegate>* delegate;

- (void) addLayoutWithRowWidth:(CGFloat) rowWidth rowHeight:(CGFloat) rowHeight layouts:(NSArray*) layouts;
- (void) clearLayout;

@end
