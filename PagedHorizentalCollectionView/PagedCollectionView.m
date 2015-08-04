//
//  PagedCollectionView.m
//  
//
//  Created by 严隐 on 15/8/4.
//
//

#import "PagedCollectionView.h"
#import "PagedHorizentalLayout.h"

@interface PagedCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PagedHorizentalLayout         *layout;
@property (nonatomic, assign) NSInteger                     currentSection;

@end


@implementation PagedCollectionView

+ (NSString *)defaultCellIdentifier
{
    return @"Cell";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commontInit];
        [self awakeFromNib];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commontInit];
    }
    
    return self;
}

- (void)setPageContentInsetsString:(NSString *)pageContentInsetsString
{
    self.pageContentInsets = UIEdgeInsetsFromString(pageContentInsetsString);
}

- (void)commontInit
{
    self.pageContentInsets = UIEdgeInsetsMake(0, 4, 12, 4);
}

-(void)setColumnCount:(NSUInteger)columnCount
{
    _columnCount = columnCount;
    self.layout.columnNum = _columnCount;
}
-(void)setPageContentInsets:(UIEdgeInsets)pageContentInsets
{
    _pageContentInsets = pageContentInsets;
    self.layout.pageContentInsets = pageContentInsets;
}

-(void)setLineCount:(NSUInteger)lineCount
{
    _lineCount = lineCount;
    self.layout.linesNum = _lineCount;
}

-(void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.layout.tileSize = _itemSize;
}

- (void)awakeFromNib
{
    self.layout = [[PagedHorizentalLayout alloc] initWithTileSize:_itemSize
                                                         linesNum:_lineCount
                                                        columnNum:_columnCount
                                                pageContentInsets:_pageContentInsets];
    CGSize size = self.bounds.size;
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = nil;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    [self registerCell];
    [self addSubview:self.collectionView];
    
    frame = CGRectMake(0, size.height - 15.0, size.width, 15.0);
    self.pageControlView = [[UIPageControl alloc] initWithFrame:frame];
    self.pageControlView.userInteractionEnabled = NO;
    [self addSubview:self.pageControlView];
    
}

- (void)registerCell
{
    NSString *cellIdentifier = self.cellIdentifier ? self.cellIdentifier : [PagedCollectionView defaultCellIdentifier];
    if (self.cellClassName != nil) {
        [self.collectionView registerClass:NSClassFromString(self.cellClassName)
                forCellWithReuseIdentifier:cellIdentifier];
    }
}

- (void)setCellClassName:(NSString *)cellClassName
{
    if (cellClassName) {
        _cellClassName = cellClassName;
        [self registerCell];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControlView.frame  =CGRectMake(0, self.frame.size.height - 15.0, self.frame.size.width, 15.0);
}

#pragma mark -  UICollection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource collectionView:collectionView numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataSource numberOfSectionsInCollectionView:collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark -  UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkIfIndexChanged:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self checkIfIndexChanged:scrollView];
}

- (void)checkIfIndexChanged:(UIScrollView *)scrollView
{
    CGPoint contentOffset = [scrollView contentOffset];
    CGFloat page = contentOffset.x / scrollView.frame.size.width;
    
    NSInteger section = [self.layout sectionFromPages:page];
    NSInteger pagesBefore = [self.layout pagesNumberBeforeSection:section];
    
    self.pageControlView.hidden = [self pageControlViewHiddenInSection:section];
    self.pageControlView.numberOfPages = [self.layout pagesNumberInSection:section];
    self.pageControlView.currentPage = page - pagesBefore;
    
    if ([_delegate respondsToSelector:@selector(pagedCollectionView:secionChanged:)]) {
        [_delegate pagedCollectionView:self secionChanged:section];
    }
}

- (BOOL)pageControlViewHiddenInSection:(NSInteger)section
{
    BOOL hidden = [self.collectionView numberOfItemsInSection:section] <= 0;
    if ([_dataSource respondsToSelector:@selector(pageControlViewShouldHideForSection:)]) {
        hidden = [_dataSource pageControlViewShouldHideForSection:section];
    }
    
    return hidden;
}

- (void)checkPageControl:(NSInteger)section
{
    self.pageControlView.numberOfPages = [self.layout pagesNumberInSection:section];
    self.pageControlView.currentPage = 0;
}

- (void)reloadData
{
    [self.collectionView reloadData];
    [self checkIfIndexChanged:self.collectionView];
}

- (void)reload
{
    self.collectionView.contentOffset = CGPointZero;
    [self reloadData];
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self selectSection:indexPath.section
                   page:indexPath.row / [self.layout maxInOnePage]
               animated:animated];
}

- (void)selectSection:(NSInteger)section animated:(BOOL)animated
{
    [self selectSection:section page:0 animated:animated];
}

- (void)selectSection:(NSInteger)section page:(NSInteger)p animated:(BOOL)animated
{
    NSInteger count = [self.collectionView numberOfSections];
    if (section >= 0 && section < count) {
        NSInteger page = [self.layout pagesNumberBeforeSection:section] + p;
        
        CGPoint contentOffset = CGPointMake(self.collectionView.frame.size.width * page, 0);
        [self.collectionView setContentOffset:contentOffset
                                     animated:animated];
        CGFloat p = contentOffset.x / self.collectionView.frame.size.width;
        
        NSInteger section = [self.layout sectionFromPages:page];
        NSInteger pagesBefore = [self.layout pagesNumberBeforeSection:section];
        
        self.pageControlView.hidden = [self pageControlViewHiddenInSection:section];
        self.pageControlView.numberOfPages = [self.layout pagesNumberInSection:section];
        self.pageControlView.currentPage = p - pagesBefore;
        
        if ([self.delegate respondsToSelector:@selector(pagedCollectionView:secionChanged:)]) {
            [self.delegate pagedCollectionView:self secionChanged:section];
        }
    }
}

- (void)hidePageControl:(BOOL)hide
{
    self.pageControlView.hidden = hide;
}

- (void)collectionPutSubview:(UIView *)subView toSection:(NSInteger )section
{
    NSInteger pageCount = [self.layout pagesNumberBeforeSection:section];
    
    CGRect rect = subView.frame;
    rect.origin.x = pageCount * self.collectionView.frame.size.width + (self.frame.size.width - subView.frame.size.width)/2;
    subView.frame = rect;
}

@end
