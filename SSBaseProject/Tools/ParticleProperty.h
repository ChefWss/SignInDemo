//
//  ParticleProperty.h
//  airpop
//
//  Created by yan on 2016/11/21.
//  Copyright © 2016年 aetheris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParticleProperty : NSObject

@property (nonatomic, assign) CGFloat speedX, speedY, radius, slowSpeed;
@property (nonatomic, assign) BOOL isDropping, isJoin;

@end
