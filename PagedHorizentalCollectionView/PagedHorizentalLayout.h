//
//  PagedHorizentalLayout.h
//  PagedHorizentalCollectionView
//
//  Created by yanyin on 9/26/14.
//  Copyright (c) 2014 roidapp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CellAligmentAverage,
    CellAligmentGap,
} CellAligment;

@interface PagedHorizentalLayout : UICollectionViewLayout

/** 作用在每一页上 */
@property (nonatomic, assign) UIEdgeInsets  contentInsets;
/** 单元的大小 */
@property (nonatomic, assign) CGSize        cellSize;
/** 水平方向的Gap  >=0 */
@property (nonatomic, assign) CGFloat       horizentalGap;
/** 垂直方向的Gap  >=0 */
@property (nonatomic, assign) CGFloat       verticalGap;
/** 对齐方式 */
@property (nonatomic, assign) CellAligment  aligment;

@end
