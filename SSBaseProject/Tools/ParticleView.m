//
//  ParticleView.m
//  airpop
//
//  Created by yan on 2016/11/18.
//  Copyright © 2016年 aetheris. All rights reserved.
//

#import "ParticleView.h"
#import "Util.h"
#import <HexColors.h>
#import <Masonry.h>
#import <POP.h>
#import "ParticleProperty.h"

@interface ParticleView ()

@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) NSMutableArray *particleProperties;
@property (nonatomic, strong) NSTimer *timer;

@end

#define WARNINGLINE self.frame.size.height

@implementation ParticleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)animation {
    for (int i = 0; i < self.particles.count; i++) {
        UIView *view = self.particles[i];
        ParticleProperty *property = self.particleProperties[i];
        if (view.center.y < WARNINGLINE && property.isDropping && !property.isJoin) {
            view.center = CGPointMake(getPointXValue(property.speedX, getPointYValue(view.center.y, property.speedY)) + view.center.x, getPointYValue(view.center.y, property.speedY));
        } else {
            if (property.isDropping) {
                CGFloat hour = self.filterTime / 1000.0f / 60 / 60;
                CGFloat probability = self.filterTime == -1 ? 60 : (hour < 0.5 ? 30 : 0);
                if (self.angleNum > 0.5 && self.angleNum < 1.0) {
                    if (!property.isJoin) {
                        view.backgroundColor = [UIColor colorWithRed:59.0f / 255.0f green:120.0f / 255.0f blue:219.0f / 255.0f alpha:0.7];
                        CGFloat alpha = view.alpha;
                        if (arc4random() % 100 < probability) {
                            view.backgroundColor = [UIColor whiteColor];
                        }
                        property.isDropping = NO;
                        POPDecayAnimation *decayAnimation=[POPDecayAnimation animationWithPropertyNamed:kPOPViewCenter];
                        CGFloat decayX = (self.center.x - view.center.x) * 0.8;
                        decayAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(decayX, 120)];
                        decayAnimation.removedOnCompletion = YES;
                        decayAnimation.deceleration = 0.998f;
                        decayAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                            if (finished) {
                                view.center = CGPointMake(arc4random() % (NSInteger)(self.frame.size.width - view.frame.size.width) + view.frame.size.width / 2, arc4random() % (NSInteger)(self.frame.size.height - view.frame.size.height) + view.frame.size.height / 2);
                                property.isDropping = YES;
                                view.backgroundColor = [UIColor whiteColor];
                                view.alpha = alpha;
                            }
                        };
                        [view pop_addAnimation:decayAnimation forKey:nil];
                    }
                } else {
                    if (!property.isJoin) {
                        property.isJoin = YES;
                        POPDecayAnimation *decayAnimation=[POPDecayAnimation animationWithPropertyNamed:kPOPViewCenter];
                        decayAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(0, -100)];
                        decayAnimation.removedOnCompletion = YES;
                        decayAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                            if (finished) {
                                property.isJoin = NO;
                            }
                        };
                        [view pop_addAnimation:decayAnimation forKey:nil];
                    }
                    view.center = CGPointMake(property.speedX * sin(view.center.y * M_PI / 180) + view.center.x, view.center.y);
                }
            }
        }
    }
}


- (NSInteger )getCountWithValue:(CGFloat )value {
    NSInteger count = 0;
    if (value < 50) {
        //rand(3)
        count = arc4random() % 4;
    }
    else if (value < 100) {
        //rand(3,5)
        count = (arc4random() % 3) + 3;
    }
    else if (value < 150) {
        //rand(5,10)
        count = (arc4random() % 6) + 5;
    }
    else if (value < 200) {
        //rand(10,15)
        count = (arc4random() % 6) + 10;
    }
    else if (value < 250) {
        //rand(15,20)
        count = (arc4random() % 6) + 15;
    }
    else if (value < 300) {
        //rand(20,25)
        count = (arc4random() % 6) + 20;
    }
    else {
        //rand(25,30)
        count = (arc4random() % 6) + 25;
    }
    return count * 2;
}

CGFloat getPointYValue(CGFloat y, CGFloat velocity) {
    return y + velocity;
}

CGFloat getPointXValue(CGFloat vx, CGFloat y) {
    return vx * sin(y * M_PI / 180.0f);
}

#pragma mark set and get

- (void)setFilterTime:(CGFloat)filterTime {
    _filterTime = filterTime;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    if (self.particles.count < count) {
        for (int i = (int)self.particles.count; i < count; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + 1;
            [view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self.particles addObject:view];
            [self addSubview:view];
            ParticleProperty *particleProperty = [[ParticleProperty alloc] init];
            particleProperty.speedX = 1.5 * (arc4random() % 10 / 10.0);
            particleProperty.speedY = 1.2 * (arc4random() % 10 / 10.0);
            while (particleProperty.speedY == 0) {
                particleProperty.speedY = 0.6 * (arc4random() % 10 / 10.0);
            }
            while (particleProperty.radius == 0) {
                particleProperty.radius = 3 * (arc4random() % 10 / 10.0);
            }
            [self.particleProperties addObject:particleProperty];
            NSInteger length = particleProperty.radius * 2;
            view.frame = CGRectMake(0, 0, length == 0 ? 1 : length, length == 0 ? 1 : length);
            view.center = CGPointMake(arc4random() % (NSInteger)(self.frame.size.width - view.frame.size.width) + view.frame.size.width / 2, arc4random() % (NSInteger)(self.frame.size.height - view.frame.size.height) + view.frame.size.height / 2);
            view.layer.cornerRadius = length / 2.0f;
            view.layer.masksToBounds = YES;

            view.alpha = arc4random() % 10 / 10.0;
            while (view.alpha < 0.2) {
                view.alpha = arc4random() % 10 / 10.0;
            }
        }
    }
}

- (NSMutableArray *)particles {
    if (!_particles) {
        _particles = [NSMutableArray array];
        self.particleProperties = [NSMutableArray array];
        for (int i = 0; i < self.count; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + 1;
            [view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [_particles addObject:view];
            ParticleProperty *particleProperty = [[ParticleProperty alloc] init];
            particleProperty.speedX = 1.5 * (arc4random() % 10 / 10.0);
            particleProperty.speedY = 1.2 * (arc4random() % 10 / 10.0);
            while (particleProperty.speedY == 0) {
                particleProperty.speedY = 0.6 * (arc4random() % 10 / 10.0);
            }
            while (particleProperty.radius == 0) {
                particleProperty.radius = 3 * (arc4random() % 10 / 10.0);
            }
            [self.particleProperties addObject:particleProperty];
        }
    }
    return _particles;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIView *view = object;
    if (view.center.x < 0 || view.center.x > self.frame.size.width) {
        view.center = CGPointMake(arc4random() % (NSInteger)(self.frame.size.width - view.frame.size.width) + view.frame.size.width / 2, arc4random() % (NSInteger)(self.frame.size.height - view.frame.size.height) + view.frame.size.height / 2);
        view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    for (UIView *view in self.particles) {
        [view removeObserver:self forKeyPath:@"center"];
    }
}

@end
