//
//  PagedHorizentalLayout.m
//  PagedHorizentalCollectionView
//
//  Created by yanyin on 9/26/14.
//

#import "PagedHorizentalLayout.h"

@implementation PagedHorizentalLayout

-(instancetype)init
{
    if (self = [super init]) {
        _tileSize = CGSizeZero;
        _linesNum = 0;
        _columnNum = 0;
        _pageContentInsets = UIEdgeInsetsZero;
    }
    return self;
}

-(instancetype)initWithTileSize:(CGSize)tileSize linesNum:(NSInteger)linesNum columnNum:(NSInteger)columnNum pageContentInsets:(UIEdgeInsets)pageContentInsets
{
    if (self=[self init]) {
        _tileSize = tileSize;
        _linesNum = linesNum;
        _columnNum = columnNum;
        _pageContentInsets = pageContentInsets;
    }
    return self;
}

-(void)prepareLayout
{
    if (_linesNum <= 0) {
        _linesNum = 2;
    }
    if (_columnNum <= 0) {
        _columnNum = 4;
    }
}

- (NSInteger)pagesNumber
{
    NSInteger pageCount = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        pageCount += [self pagesNumberInSection:i];
    }
    
    return pageCount;
}

- (NSInteger)pagesNumberInSection:(NSInteger)section
{
    if (section >= self.collectionView.numberOfSections || section < 0) {
        NSAssert(NO, @"Please check whether the \"section\" input parameter is right");
        return 0;
    }
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    return (itemCount - 1) / (_linesNum * _columnNum) + 1;
}

- (NSInteger)maxInOnePage
{
    return _linesNum * _columnNum;
}

- (NSInteger)pagesNumberBeforeSection:(NSInteger)secion
{
    NSInteger pages = 0;
    NSInteger s = 0;
    while (s < secion) {
        pages += [self pagesNumberInSection:s];
        s++;
    }
    
    return pages;
}

- (NSInteger)sectionFromPages:(NSInteger)pages
{
    NSInteger s = 0;
    while ((pages -= [self pagesNumberInSection:s]) >= 0) {
        s++;
    }
    return s;
}


- (CGSize)collectionViewContentSize
{
    CGSize visibleSize = self.collectionView.frame.size;
    CGSize size = CGSizeMake([self pagesNumber] * visibleSize.width,
                             visibleSize.height);
    return size;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        for (NSInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.tileSize;
    
    CGRect frame = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.pageContentInsets);
    
    CGFloat width = frame.size.width / (_columnNum *2);
    CGFloat height = frame.size.height / (_linesNum *2);
    
    NSInteger secion = indexPath.section;
    NSInteger pages = 0;
    while (secion > 0) {
        secion--;
        pages += [self pagesNumberInSection:secion];
    }
    
    CGFloat left = pages * self.collectionView.frame.size.width;
    
    
    CGFloat x = width * (2*(indexPath.item%_columnNum) +1) + indexPath.item/(_columnNum * _linesNum) * self.collectionView.bounds.size.width+self.pageContentInsets.left;
    CGFloat y = height * (2*((indexPath.item % (_columnNum * _linesNum))/_columnNum) +1)+self.pageContentInsets.top;
    attributes.center = CGPointMake(left + x, y);
    return attributes;
}

@end
