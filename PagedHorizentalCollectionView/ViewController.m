//
//  ViewController.m
//  PagedHorizentalCollectionView
//
//  Created by yanyin on 9/26/14.
//  Copyright (c) 2014 roidapp. All rights reserved.
//

#import "ViewController.h"
#import "PagedHorizentalLayout.h"
#import "Cell.h"

@interface ViewController ()<UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UICollectionView     *collectionView;
@property (nonatomic, strong) NSString *cellIdentifier;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cellIdentifier = @"cell";
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:self.cellIdentifier];
    self.collectionView.pagingEnabled = YES;
    PagedHorizentalLayout *layout = (PagedHorizentalLayout *) self.collectionView.collectionViewLayout;
    layout.cellSize = CGSizeMake(75, 50);
    layout.horizentalGap = 10;
    layout.verticalGap = 10;
    layout.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.aligment = CellAligmentGap;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UICollection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 37;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}



@end
