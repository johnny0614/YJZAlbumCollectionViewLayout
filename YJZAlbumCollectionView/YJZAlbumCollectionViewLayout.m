//
//  YJZAlbumCollectionViewLayout.m
//  YJZAlbumCollectionView
//
//  Created by YU JOHNNY ZHOU on 18/08/2014.
//  Copyright (c) 2014 YU JOHNNY ZHOU. All rights reserved.
//

#import "YJZAlbumCollectionViewLayout.h"

@interface YJZAlbumCollectionViewLayout ()

@property (nonatomic) int numberOfRows;
/**
 rowLayouts structure :
 {
    layouts : [
        {
            rowHeight: ... ,
            rowWidth : collectionView.frame.size.width (default),
            available : [CGRect],
            filled : [CGRect]
            blocks :
        },
        ...
    ],
    selected : ...
    height : ...
    width : ...
    totalBlocks : ...
 }
 */
@property (nonatomic) NSMutableDictionary *layouts;

/**
 placedIndexPath structure :
 {
    key (indexpath) : value (CGRect)
    ...
 }
 */
@property (nonatomic) NSMutableDictionary *placedIndexPath;
@property (nonatomic) NSIndexPath *lastIndexPathPlaced;

@end

@implementation YJZAlbumCollectionViewLayout {
    
}

//initialization procture
- (id)init {
    if((self = [super init]))
        [self initialize];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initialize];
    }
    return self;
}

- (void) initialize {
    // defaults
    self.direction = UICollectionViewScrollDirectionVertical;
    self.blockSize = CGSizeMake(100.f, 100.f);
    self.rowHeight = 100.f;
}

- (void) prepareLayout {
    [super prepareLayout];
    
    if(!self.delegate) return;
    
    if (!_layouts) {
        //add default row layouts
    }
}

- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.rowHeight*_numberOfRows);
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    return nil;
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if([self.delegate respondsToSelector:@selector(insetsForItemAtIndexPath:)])
        insets = [self.delegate insetsForItemAtIndexPath:indexPath];
    
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

#pragma mark - API

- (BOOL) addLayout:(NSDictionary *)rowLayout {
    return NO;
}

#pragma mark - helper method


- (BOOL) placeBlockAtIndexPath: (NSIndexPath *)indexPath {
    int selected = [[_layouts objectForKey:@"selected"] intValue];
    NSMutableDictionary* layout = [_layouts valueForKey:@"layouts"][selected];
    NSMutableArray *avaiable = [layout valueForKey:@"avaiable"];
    NSMutableArray *filled = [layout valueForKey:@"filled"];
    CGRect selectedLayout = [[avaiable objectAtIndex:0] CGRectValue];
    [avaiable removeObjectAtIndex:0];
    [filled addObject:[NSValue valueWithCGRect:selectedLayout]];
    
    //place block for indexPath
    
    
    
    //current row is fullfilled
    if ([avaiable count] == 0) {
        [layout setValue:filled forKey:@"avaiable"];
        [layout setValue:avaiable forKey:@"filled"];
        [_layouts setObject:[NSNumber numberWithInt:selected++] forKey:@"selected"];
    }
    
    
    return NO;
}

- (void) fillBlocksToRow:(int) endRow {
    NSInteger numOfSections = [self.collectionView numberOfSections];
    for (NSInteger section=self.lastIndexPathPlaced.section; section < numOfSections; section ++) {
        NSInteger numOfRows = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger row = (!self.lastIndexPathPlaced?0 : self.lastIndexPathPlaced.row + 1); row < numOfRows; row++) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if ([self placeBlockAtIndexPath:currentIndexPath]) {
                self.lastIndexPathPlaced = currentIndexPath;
            }
            
            // exit condition :
        }
    }
}

- (void) fillBlocksToIndexPath: (NSIndexPath *) path {
    
    NSInteger numOfSections = [self.collectionView numberOfSections];
    for (NSInteger section=self.lastIndexPathPlaced.section; section < numOfSections; section++) {
        NSInteger numOfRows = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger row = (!self.lastIndexPathPlaced? 0 : self.lastIndexPathPlaced.row + 1); row < numOfRows; row++) {
            
            //exit condition : indexpath passed
            if (section >= path.section && row > path.row) {
                //TO DO : Reset Layouts Dictionary
                return;
            }
            
            NSIndexPath * currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if ([self placeBlockAtIndexPath:currentIndexPath]) {
                self.lastIndexPathPlaced = currentIndexPath;
            }
        }
    }
}

@end
