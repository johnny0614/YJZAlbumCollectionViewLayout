//
//  YJZViewController.m
//  YJZAlbumCollectionView
//
//  Created by YU JOHNNY ZHOU on 18/08/2014.
//  Copyright (c) 2014 YU JOHNNY ZHOU. All rights reserved.
//

#import "YJZViewController.h"
#import "YJZAlbumCollectionViewLayout.h"

@interface YJZViewController () <UICollectionViewDelegate, UICollectionViewDataSource, YJZAlbumCollectionViewDelegate>

@property (nonatomic) NSMutableArray* numbers;


@end

int num = 0;

@implementation YJZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self datasInit];
	// Do any additional setup after loading the view, typically from a nib.
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    YJZAlbumCollectionViewLayout* layout = (id)[self.collectionView collectionViewLayout];
    
    [layout clearLayout];
    [layout addLayoutWithRowWidth:320.f rowHeight:100.f layouts:@[[NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(80.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 0.f, 80.f, 100.f)]]];
    
    [layout addLayoutWithRowWidth:320.f rowHeight:100.f layouts:@[[NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 160.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 0.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 0.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 50.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 50.f, 80.f, 50.f)]]];
    
    layout.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    [self.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)datasInit {
    num = 0;
    self.numbers = [@[] mutableCopy];
    for(; num<30; num++) {
        [self.numbers addObject:@(num)];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - YJZAlbumCollectonViewLayoutDelegate

- (UIEdgeInsets) insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f);
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
        
    return cell;
}

#pragma mark - helper
- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

@end
