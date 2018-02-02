//
//  ParticleView.h
//  airpop
//
//  Created by yan on 2016/11/18.
//  Copyright © 2016年 aetheris. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat getPointYValue(CGFloat y, CGFloat velocity);
CGFloat getPointXValue(CGFloat vx, CGFloat y);

typedef NS_ENUM(NSInteger, ParticleViewAnimationType) {
    ParticleViewAnimationTypeDrop,
    ParticleViewAnimationTypeDecay
};


@interface ParticleView : UIView

@property (nonatomic, assign) CGFloat angleNum; // MaskHomeView circle turn angle 0 - 1.0
@property (nonatomic, assign) CGFloat filterTime; // range [0, 1000 * 60 * 60 * 8]  -1 no filter
@property (nonatomic, assign) NSInteger count;

- (void)animation;

@end
