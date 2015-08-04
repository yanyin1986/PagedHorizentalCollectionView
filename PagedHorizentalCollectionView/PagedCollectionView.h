//
//  PagedCollectionView.h
//  
//
//  Created by leon.yan on 15/8/4.
//
//

#import <UIKit/UIKit.h>

@class PagedCollectionView;
@protocol PagedCollectionViewDelegate <UICollectionViewDelegate>

@required
- (void)pagedCollectionView:(PagedCollectionView *)collectionView secionChanged:(NSInteger)section;

@end

@protocol PagedCollectionViewDataSource <UICollectionViewDataSource>

@optional
- (BOOL)pageControlViewShouldHideForSection:(NSInteger)section;

@end

@interface PagedCollectionView : UIView

@property(nonatomic, weak  ) IBOutlet  id<PagedCollectionViewDataSource>   dataSource;
@property(nonatomic, weak  ) IBOutlet  id<PagedCollectionViewDelegate>     delegate;
@property(nonatomic, strong) UICollectionView              *collectionView;
@property(nonatomic, strong) UIPageControl                 *pageControlView;

@property(nonatomic, assign) CGSize                itemSize;
@property(nonatomic, assign) NSUInteger            lineCount;
@property(nonatomic, assign) NSUInteger            columnCount;
@property(nonatomic, assign) UIEdgeInsets          pageContentInsets;
@property(nonatomic, strong) NSString              *pageContentInsetsString;

@property(nonatomic, strong) NSString              *cellClassName;
@property(nonatomic, strong) NSString              *cellIdentifier;

+ (NSString *)defaultCellIdentifier;
- (void)reloadData;
- (void)reload;
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)selectSection:(NSInteger)section animated:(BOOL)animated;
- (void)selectSection:(NSInteger)section page:(NSInteger)page animated:(BOOL)animated;
- (void)checkPageControl:(NSInteger)section;

- (void)collectionPutSubview:(UIView *)subView toSection:(NSInteger )section;


@end
