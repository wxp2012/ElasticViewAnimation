//
//  UIView+DegressCenter.m
//  ElasticViewAnimation
//
//  Created by xp_mac on 16/1/11.
//  Copyright © 2016年 xp_mac. All rights reserved.
//

#import "UIView+DegressCenter.h"

@implementation UIView (DegressCenter)

- (CGPoint) usePresentationLayerIfPossible:(BOOL)theBool
{
    if (theBool == YES) {
        
        CALayer *theLayer = self.layer;
        return [[theLayer presentationLayer] position];
    }
    
    return self.center;
}

@end
