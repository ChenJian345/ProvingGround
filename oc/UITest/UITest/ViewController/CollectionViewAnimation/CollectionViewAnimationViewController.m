//
//  CollectionViewAnimationViewController.m
//  UITest
//
//  Created by Mark on 2018/3/12.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "CollectionViewAnimationViewController.h"
#import "CollectionViewAnimationCell.h"

@interface CollectionViewAnimationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

#define COLLECTION_VIEW_CELL_IDENTIFIER         @"collection_view_cell_identifier"

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAnimation;
@property (nonatomic, strong) NSArray *arrDataSource;

@end

@implementation CollectionViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Coll Animation";
    
    self.arrDataSource = @[@"具体", @"实例化", @"步骤", @"均在", @"代码", @"中有", @"注释", @"注意", @"重用", @"问题", @"你的", @"代码可以", @"做如下修改"];
    [self setupCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    const int JUMP_HEIGHT = 200;
    CGRect frameOrigin = self.collectionViewAnimation.frame;
    CGRect frameDestination = frameOrigin;
    frameDestination.origin.y -= JUMP_HEIGHT;
    frameDestination.size.height += JUMP_HEIGHT;

    [UIView animateKeyframesWithDuration:8 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.6 animations:^{
            self.collectionViewAnimation.frame = frameDestination;
            [self.collectionViewAnimation layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4 animations:^{
            self.collectionViewAnimation.frame = frameOrigin;
            [self.collectionViewAnimation layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
    
    }];
    
//    [UIView animateWithDuration:5 animations:^{
//        self.collectionViewAnimation.frame = frameDestination;
//        [self.collectionViewAnimation layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:3 animations:^{
//            self.collectionViewAnimation.frame = frameOrigin;
//            [self.collectionViewAnimation layoutIfNeeded];
//        } completion:^(BOOL finished) {
//
//        }];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Init
- (void)setupCollectionView {
    if (self.collectionViewAnimation != nil) {
        UINib *nib = [UINib nibWithNibName:@"CollectionViewAnimationCell" bundle:[NSBundle mainBundle]];
        [self.collectionViewAnimation registerNib:nib forCellWithReuseIdentifier:COLLECTION_VIEW_CELL_IDENTIFIER];
        self.collectionViewAnimation.delegate = self;
        self.collectionViewAnimation.dataSource = self;
    }
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewAnimationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
    if (cell != nil) {
        
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrDataSource.count;
}

@end
