//
//  GMCollectionViewCell.m
//  GMSnippets
//
//  Created by Mustafa on 27/01/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMCollectionViewCell.h"

@interface GMCollectionViewCell ()

@property (nonatomic, weak) UICollectionView *currentCollectionView;
@property (nonatomic, weak) id actionTarget;
@property (nonatomic, weak) id indexPath;

@end

@implementation GMCollectionViewCell

+ (void)registerCellForCollectionView:(UICollectionView *)cv {
    NSString *className = NSStringFromClass([self class]);
    
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
    
    if (nib) {
        [cv registerNib:nib forCellWithReuseIdentifier:className];
        
    } else {
        [cv registerClass:self forCellWithReuseIdentifier:className];
    }
}

+ (id)cellForCollectionView:(UICollectionView *)cv atIndexPath:(NSIndexPath *)indexPath target:(id)target {
    NSString *className = NSStringFromClass([self class]);
    
    GMCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
        
        if (nib) {
            [cv registerNib:nib forCellWithReuseIdentifier:className];
            
        } else {
            [cv registerClass:self forCellWithReuseIdentifier:className];
        }
        
        cell = [cv dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    }
    
    [cell setActionTarget:target];
    [cell setIndexPath:indexPath];
    [cell setCurrentCollectionView:cv];
    
    return cell;
}

- (void)routeAction:(SEL)act fromObject:(id)obj {
    [self dispatchMessage:act toObject:[self actionTarget] fromObject:obj];
}

- (void)dispatchMessage:(SEL)msg toObject:(id)obj fromObject:(UIControl *)ctl {
    SEL newSel = NSSelectorFromString([NSStringFromSelector(msg) stringByAppendingFormat:@"atIndexPath:"]);
    NSIndexPath *ip = [[self currentCollectionView] indexPathForCell:self];
    
    if (ip) {
        // Developer's Note:
        // We've added the following #pragma statements to supress the warning:
        // "performSelector may cause a leak because its selector is unknown",
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [obj performSelector:newSel withObject:ctl withObject:ip];
#pragma clang diagnostic pop
    }
}

@end
