//
//  PagedHorizentalLayout.h
//  PagedHorizentalCollectionView
//
//  Created by leon.yan on 9/26/14.
//

#import <UIKit/UIKit.h>

@interface PagedHorizentalLayout : UICollectionViewLayout

@property (nonatomic,assign) CGSize tileSize;
@property (nonatomic,assign) NSInteger linesNum;
@property (nonatomic,assign) NSInteger columnNum;
@property (nonatomic,assign) UIEdgeInsets pageContentInsets;

- (instancetype)initWithTileSize:(CGSize)tileSize
                        linesNum:(NSInteger)linesNum
                       columnNum:(NSInteger)columnNum
               pageContentInsets:(UIEdgeInsets)pageContentInsets;
/** 返回所有的页面的数量 */
- (NSInteger)pagesNumber;
/** 返回该section下页面的数量 */
- (NSInteger)pagesNumberInSection:(NSInteger)section;
/** 返回该section前还有的页面数量 */
- (NSInteger)pagesNumberBeforeSection:(NSInteger)secion;
/** 返回一页里面最多的item数量 */
- (NSInteger)maxInOnePage;

- (NSInteger)sectionFromPages:(NSInteger)pages;

@end
