//
//  NPSendVideoBottomView.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoBottomView.h"
#import <Masonry.h>
#import "NPMediaFetcher.h"

@interface NPSendVideoBottomCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation NPSendVideoBottomCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

@end

@interface NPSendVideoBottomView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation NPSendVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = floor(10);
        layout.minimumLineSpacing = floor(10);
        layout.itemSize = CGSizeMake(floor(65), 81.5);
        _collectionView = [[UICollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:NPSendVideoBottomCollectionViewCell.class forCellWithReuseIdentifier: NSStringFromClass(NPSendVideoBottomCollectionViewCell.class)];
    }
    return _collectionView;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NPSendVideoBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(NPSendVideoBottomCollectionViewCell.class) forIndexPath:indexPath];
    
    [NPMediaFetcher getVideoImage:self.dataList[indexPath.row] handler:^(UIImage * _Nonnull origion) {
        cell.imageView.image = origion;
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectValue) {
        self.selectValue(self.dataList[indexPath.row]);
    }
}


@end
