YJZAlbumCollectionViewLayout
======================

YJZAlbumCollectionViewLayout is a [UICollectionViewLayout](http://developer.apple.com/library/ios/#documentation/UIKit/Reference/UICollectionViewLayout_class/Reference/Reference.html#//apple_ref/occ/cl/UICollectionViewLayout) subclass, used as the layout object of [UICollectionView](http://developer.apple.com/library/ios/#documentation/UIKit/Reference/UICollectionView_class/Reference/Reference.html). 

The idea of **YJZAlbumCollectionViewLayout** is inspired by [RFQuiltLayout](https://github.com/bryceredd/RFQuiltLayout). The purpose of it is to allow users to create their desired collection layouts simply and straightforward.  

| Default                                          | Custom                                     |
| ------------------------------------------------ |:------------------------------------------:|
| ![Demo 1](http://i.imgur.com/4LYZUCT.png?1)      | ![Demo 2](http://i.imgur.com/gOhfk1S.png?1)|


How to use
----------------------

Add the layout as the subclass of your UICollectionViewLayout.

![Subclass the layout](http://i.imgur.com/N8X9MHS.png?1)


*The following code is to create the above custom collection layout*

    - (void) viewDidLoad {
      // ...

      YJZAlbumCollectionViewLayout* layout = (id)[self.collectionView collectionViewLayout];
    
      [layout clearLayout];
      [layout addLayoutWithRowWidth:320.f rowHeight:100.f layouts:@[[NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(80.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 0.f, 80.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 0.f, 80.f, 100.f)]]];
    
      [layout addLayoutWithRowWidth:320.f rowHeight:100.f layouts:@[[NSValue valueWithCGRect:CGRectMake(0.f, 0.f, 160.f, 100.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 0.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 0.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(160.f, 50.f, 80.f, 50.f)],[NSValue valueWithCGRect:CGRectMake(240.f, 50.f, 80.f, 50.f)]]];
    
      layout.delegate = self;
    
      // ... 
    }
    
    - (UIEdgeInsets) insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
      return UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f);
    }

(Note: all delegate methods are optional)

API
------------------------------

**All api methods must be called before prepareLayout is called.**

    // add a custom row layout
    - (void) addLayoutWithRowWidth:(CGFloat) rowWidth rowHeight:(CGFloat) rowHeight layouts:(NSArray*) layouts;
    //clear all current layouts
    - (void) clearLayout;



