//
//  YJZAlbumCollectionViewLayout.m
//  YJZAlbumCollectionView
//
//  Created by YU JOHNNY ZHOU on 18/08/2014.
//  Copyright (c) 2014 YU JOHNNY ZHOU. All rights reserved.
//

#import "YJZAlbumCollectionViewLayout.h"

@interface YJZAlbumCollectionViewLayout ()

/**
 layouts structure :
 {
    maxWidth: float,
    selected: int,
    layouts: [
        {
            available: array<CGRect>,
            filled: array<CGRect>,
            rowHeight: float,
            rowWidth: float
        },
    ]
 }
 */
@property (nonatomic) NSMutableDictionary *layouts;

@property (nonatomic) CGFloat bottomline;
@property (nonatomic) CGFloat viewHeight;

/**
 placedIndexPath structure :
 {
    key (indexpath) : value (CGRect)
    ...
 }
 */
@property (nonatomic) NSMutableDictionary *placedIndexPath;
@property (nonatomic) NSIndexPath *lastIndexPathPlaced;
@property (nonatomic) BOOL beforePrepareLayout;

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
    
    _placedIndexPath = [NSMutableDictionary dictionary];
    _lastIndexPathPlaced = nil;
    _bottomline = 0.f;
    _viewHeight = 0.f;
    _beforePrepareLayout = NO;
    
    if (!_layouts) {
        //default layout setting
        
        _layouts = [NSMutableDictionary dictionary];
        
        [_layouts setObject:[NSNumber numberWithInt:0 ] forKey:@"selected"];
        [_layouts setObject:[NSNumber numberWithFloat:320.f] forKey:@"maxWidth"];
        
        NSMutableArray* layout = [NSMutableArray array];
        
        NSMutableDictionary* layout_1 = [NSMutableDictionary dictionary];
        NSMutableDictionary* layout_2 = [NSMutableDictionary dictionary];
        
        CGRect frame_1 = CGRectMake(0.f, 0.f, 320.f, 50.f);
        CGRect frame_2 = CGRectMake(0.f, 0.f, 160.f, 50.f);
        CGRect frame_3 = CGRectMake(160.f, 0.f, 160.f, 50.f);
        
        NSMutableArray* available_1 = [NSMutableArray array];
        NSMutableArray* filled_1 = [NSMutableArray array];
        NSMutableArray* available_2 = [NSMutableArray array];
        NSMutableArray* filled_2 = [NSMutableArray array];
        
        [available_1 addObject:[NSValue valueWithCGRect:frame_1]];
        [available_2 addObject:[NSValue valueWithCGRect:frame_2]];
        [available_2 addObject:[NSValue valueWithCGRect:frame_3]];
        
        [layout_1 setObject:available_1 forKey:@"available"];
        [layout_1 setObject:filled_1 forKey:@"filled"];
        [layout_1 setObject:[NSNumber numberWithFloat:320.f] forKey:@"rowWidth"];
        [layout_1 setObject:[NSNumber numberWithFloat:50.f] forKey:@"rowHeight"];
        
        [layout_2 setObject:available_2 forKey:@"available"];
        [layout_2 setObject:filled_2 forKey:@"filled"];
        [layout_2 setObject:[NSNumber numberWithFloat:320.f] forKey:@"rowWidth"];
        [layout_2 setObject:[NSNumber numberWithFloat:50.f] forKey:@"rowHeight"];
        
        [layout addObject:layout_1];
        [layout addObject:layout_2];
        
        [_layouts setObject:layout forKey:@"layouts"];
        
    }
    
}

- (void) prepareLayout {
    [super prepareLayout];
    
    NSIndexPath *lastCellIndexPath = nil;
    
    _beforePrepareLayout = YES;
    
    NSInteger nSections = [self.collectionView numberOfSections];
    for (int j=0; j<nSections; j++) {
        NSInteger nRows = [self.collectionView numberOfItemsInSection:j];
        for (int i=0; i<nRows; i++) {
            lastCellIndexPath = [NSIndexPath indexPathForRow:i inSection:j];
        }
    }
    
    [self fillBlocksToIndexPath:lastCellIndexPath];
}

- (CGSize) collectionViewContentSize {
    NSLog(@"1 %@",[NSValue valueWithCGSize: CGSizeMake([[_layouts valueForKey:@"maxWidth"] floatValue], _viewHeight)]);
    return CGSizeMake([[_layouts valueForKey:@"maxWidth"] floatValue], _viewHeight);
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSIndexPath *lastCellIndexPath = nil;
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath* indexpath = [self.collectionView indexPathForCell:cell];
        if (!lastCellIndexPath) {
            lastCellIndexPath = indexpath;
        }
        if (indexpath.section > lastCellIndexPath.section || indexpath.row > lastCellIndexPath.row) {
            lastCellIndexPath = indexpath;
        }
    }
    if (![[_placedIndexPath allKeys] containsObject:lastCellIndexPath]) {
        [self fillBlocksToIndexPath:lastCellIndexPath];
    }
    
    NSMutableSet* attributes = [NSMutableSet set];
    for (NSIndexPath* path in [_placedIndexPath allKeys]) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:path]];
    }
    
    return [attributes allObjects];
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if([self.delegate respondsToSelector:@selector(insetsForItemAtIndexPath:)])
        insets = [self.delegate insetsForItemAtIndexPath:indexPath];
    
    if (![[_placedIndexPath allKeys] containsObject:indexPath]) {
        [self fillBlocksToIndexPath:indexPath];
        
    }
    
    CGRect frame = [[_placedIndexPath objectForKey:indexPath] CGRectValue];
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = UIEdgeInsetsInsetRect(frame, insets);
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    for(UICollectionViewUpdateItem* item in updateItems) {
        if(item.updateAction == UICollectionUpdateActionInsert || item.updateAction == UICollectionUpdateActionMove) {
            [self fillBlocksToIndexPath:item.indexPathAfterUpdate];
        }
    }
}

- (void) invalidateLayout {
    [super invalidateLayout];
    [_layouts setObject:[NSNumber numberWithInt:0] forKey:@"selected"];
    for (NSMutableDictionary* layout in [_layouts valueForKey:@"layouts"]) {
        if ([[layout valueForKey:@"filled"] count] == 0) {
            
        } else {
            [[layout valueForKey:@"filled"] addObjectsFromArray:[layout valueForKey:@"available"]];
            [layout setObject:[layout valueForKey:@"filled"] forKey:@"available"];
            [layout setObject:[NSMutableArray array] forKey:@"filled"];
        }
    }
    [self resetPosition];
}

#pragma mark - API

//Only be called before prepareLayout is called
- (void) addLayoutWithRowWidth:(CGFloat)rowWidth rowHeight:(CGFloat)rowHeight layouts:(NSArray *)layouts {
    
    if (_beforePrepareLayout) {
        return;
    }
    
    CGFloat maxWidth = [[_layouts valueForKey:@"maxWidth"] floatValue];
    if (maxWidth < rowWidth) {
        [_layouts setObject:[NSNumber numberWithFloat:rowWidth] forKey:@"maxWidth"];
    }
    NSMutableDictionary* newLayout = [NSMutableDictionary dictionary];
    [newLayout setObject:[NSNumber numberWithFloat:rowWidth] forKey:@"rowWidth"];
    [newLayout setObject:[NSNumber numberWithFloat:rowHeight] forKey:@"rowHeight"];
    [newLayout setObject:[NSMutableArray array] forKey:@"filled"];
    [newLayout setObject:[NSMutableArray arrayWithArray:layouts] forKey:@"available"];
    
    [[_layouts valueForKey:@"layouts"] addObject:newLayout];
    
}

//Only be called before prepareLayout is called
- (void) clearLayout {
    if (_beforePrepareLayout) {
        return;
    }
    _layouts = [NSMutableDictionary dictionary];
    [_layouts setObject:[NSNumber numberWithInt:0 ] forKey:@"selected"];
    [_layouts setObject:[NSNumber numberWithFloat:0.f] forKey:@"maxWidth"];
    [_layouts setObject:[NSMutableArray array] forKey:@"layouts"];
}

#pragma mark - helper method


- (BOOL) placeBlockAtIndexPath: (NSIndexPath *)indexPath {
    
    
    //already placed
    if ([[_placedIndexPath allKeys] containsObject:indexPath]) {
        return YES;
    }
    
    int selected = [[_layouts objectForKey:@"selected"] intValue];
    NSMutableDictionary* layout = [_layouts valueForKey:@"layouts"][selected];
    NSMutableArray *avaiable = [layout valueForKey:@"available"];
    NSMutableArray *filled = [layout valueForKey:@"filled"];
    
    if ([filled count] == 0) {
        _viewHeight += [[layout valueForKey:@"rowHeight"] floatValue];
    }
    
    CGRect selectedLayout = [[avaiable objectAtIndex:0] CGRectValue];
    [avaiable removeObjectAtIndex:0];
    //NSLog(@"%@", NSStringFromCGRect(selectedLayout));

    [filled addObject:[NSValue valueWithCGRect:selectedLayout]];
    
    //adjust top value of frame and place block for indexPath
    CGRect frame = CGRectMake(selectedLayout.origin.x, selectedLayout.origin.y+_bottomline, selectedLayout.size.width, selectedLayout.size.height);
    [_placedIndexPath setObject:[NSValue valueWithCGRect:frame]  forKey:indexPath];
    _lastIndexPathPlaced = indexPath;
    
    
    //current row is fullfilled
    if ([avaiable count] == 0) {
        _bottomline = _bottomline + [[layout objectForKey:@"rowHeight"] floatValue];

        [layout setValue:filled forKey:@"available"];
        [layout setValue:[NSMutableArray array] forKey:@"filled"];
        int next = (selected + 1) % [[_layouts valueForKey:@"layouts"] count];
        [_layouts setObject:[NSNumber numberWithInt:next] forKey:@"selected"];
    }
    
    
    return YES;
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

- (void) resetPosition {
    _lastIndexPathPlaced = nil;
    _bottomline = 0.f;
    _viewHeight = 0.f;
    _placedIndexPath = [NSMutableDictionary dictionary];
}

@end
