//
//  GMCollectionViewCell.h
//  GMSnippets
//
//  Created by Mustafa on 27/01/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GMROUTE(x) [self routeAction:_cmd fromObject:x]

@interface GMCollectionViewCell : UICollectionViewCell

+ (void)registerCellForCollectionView:(UICollectionView *)cv;

+ (id)cellForCollectionView:(UICollectionView *)cv atIndexPath:(NSIndexPath *)indexPath target:(id)target;

- (void)routeAction:(SEL)act fromObject:(id)obj;

- (void)dispatchMessage:(SEL)msg toObject:(id)obj fromObject:(UIControl *)ctl;

@end
