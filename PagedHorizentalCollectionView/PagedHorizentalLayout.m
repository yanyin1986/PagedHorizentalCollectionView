//
//  PagedHorizentalLayout.m
//  PagedHorizentalCollectionView
//
//  Created by yanyin on 9/26/14.
//  Copyright (c) 2014 roidapp. All rights reserved.
//

#import "PagedHorizentalLayout.h"

@interface PagedHorizentalLayout()

@property (nonatomic, assign) NSUInteger    cellCount;
@property (nonatomic, assign) CGFloat       xCount;
@property (nonatomic, assign) CGFloat       yCount;

@property (nonatomic, assign) CGFloat       maxHorizentalGap;
@property (nonatomic, assign) CGFloat       maxVerticalGap;

@end

@implementation PagedHorizentalLayout

- (void)prepareLayout
{
    [super prepareLayout];
    _xCount = -1;
    _yCount = -1;
    _maxHorizentalGap = -1;
    _maxVerticalGap = -1;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
}

- (CGSize)collectionViewContentSize
{
    NSLog(@"collection frame-> %@", NSStringFromCGRect(self.collectionView.frame));
    NSUInteger pageCount = [self pageCount];
    return CGSizeMake(self.collectionView.frame.size.width * pageCount, self.collectionView.frame.size.height);
}

- (void)setHorizentalGap:(CGFloat)horizentalGap
{
    if (_horizentalGap != horizentalGap) {
        _horizentalGap = horizentalGap < 0 ? 0 : horizentalGap;
    }
}

- (void)setVerticalGap:(CGFloat)verticalGap
{
    if (_verticalGap != verticalGap) {
        _verticalGap = verticalGap < 0 ? 0 : verticalGap;
    }
}

- (CGRect)contentFrame
{
    return UIEdgeInsetsInsetRect(CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height), self.contentInsets);
}

- (CGFloat)xCount
{
    if (_xCount < 0) {
        CGSize contentSize = [self contentFrame].size;
        _xCount = floorf((contentSize.width + self.horizentalGap) / (self.cellSize.width + self.horizentalGap));
    }
    return _xCount;
}

- (CGFloat)yCount
{
    if (_yCount < 0) {
        CGSize contentSize = UIEdgeInsetsInsetRect(self.collectionView.frame, self.contentInsets).size;
        _yCount = floorf((contentSize.height + self.verticalGap) / (self.cellSize.height + self.verticalGap));
    }
    return _yCount;
}

- (CGFloat)maxHorizentalGap
{
    if (_maxHorizentalGap < 0) {
        _maxHorizentalGap = ([self contentFrame].size.width - self.xCount * _cellSize.width) / (self.xCount - 1);
    }
    
    return _maxHorizentalGap;
}

- (CGFloat)maxVerticalGap
{
    if (_maxVerticalGap < 0) {
        _maxVerticalGap = ([self contentFrame].size.height - self.yCount * _cellSize.height) / (self.yCount - 1);
    }
    
    return _maxVerticalGap;
}


- (NSUInteger)pageCount
{
    CGFloat xyCount = [self xCount] * [self yCount];
    NSUInteger pageCount = _cellCount / xyCount;
    pageCount = pageCount * xyCount < _cellCount ? pageCount + 1 : pageCount;

    NSLog(@"----page count = [%ld] ----", pageCount);
    return pageCount;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = _cellSize;
    
    NSInteger numberInAPage = self.xCount * self.yCount;
    NSInteger row = indexPath.row;
    NSInteger page = row / numberInAPage;
    row = row - page * numberInAPage;
    
    NSInteger y = (NSInteger) (row / self.xCount);
    NSInteger x = row % ((NSInteger) self.xCount);
    
    CGSize viewSize = self.collectionView.frame.size;
    CGRect contentRect = [self contentFrame];
    
    CGRect frame = CGRectZero;
    
    CGFloat horGap;
    CGFloat verGap;
    switch (self.aligment) {
        default:
        case CellAligmentGap:
        {
            horGap = self.horizentalGap > self.maxHorizentalGap ? self.maxHorizentalGap : self.horizentalGap;
            verGap = self.verticalGap > self.maxVerticalGap ? self.maxVerticalGap : self.verticalGap;
        }
            break;
        case CellAligmentAverage:
        {
            
            horGap = self.maxHorizentalGap;
            verGap = self.maxVerticalGap;
        }
            break;
    }
    
    frame = CGRectMake(contentRect.origin.x + viewSize.width * page + x * (_cellSize.width + horGap),
                       contentRect.origin.y + y * (_cellSize.height + verGap),
                       _cellSize.width,
                       _cellSize.height);
    
    NSLog(@"[%ld, %ld] = %@", x, y, NSStringFromCGRect(frame));

    attribute.frame = frame;
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return array;
}

@end
