//
//  ViewController.m
//  PagedHorizentalCollectionView
//
//  Created by yanyin on 9/26/14.
//  Copyright (c) 2014 roidapp. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "PagedCollectionView.h"

@interface ViewController ()<PagedCollectionViewDataSource, PagedCollectionViewDelegate>

@property (nonatomic, strong) IBOutlet PagedCollectionView     *collectionView;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array =
    @[
      @[ @(1), @(2), @(3), @(4)],
      @[ @(1), @(2), @(3),],
      @[ @(1), @(2), @(3), @(4), @(5), @(6), @(1), @(2), @(3), @(4), @(5), @(6), @(1), @(2), @(3), @(4), @(5), @(6),],
      ];
    self.cellIdentifier = @"cell";
    self.collectionView.cellIdentifier = self.cellIdentifier;
    self.collectionView.cellClassName = @"Cell";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.itemSize = CGSizeMake(75, 50);
    self.collectionView.columnCount = 4;
    self.collectionView.lineCount = 4;
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  PagedCollectionViewDataSource
- (void)pagedCollectionView:(PagedCollectionView *)collectionView secionChanged:(NSInteger)section{
    NSLog(@"change section to %ld", (long)section);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_array[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.backgroundColor = [UIColor blueColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor redColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
    
    
    return cell;
}



@end
