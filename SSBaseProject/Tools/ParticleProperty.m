//
//  ParticleProperty.m
//  airpop
//
//  Created by yan on 2016/11/21.
//  Copyright © 2016年 aetheris. All rights reserved.
//

#import "ParticleProperty.h"

@implementation ParticleProperty

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDropping = YES;
        self.isJoin = NO;
    }
    return self;
}

@end
