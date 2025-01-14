//
//  WildCardProgressBar.m
//  devilcore
//
//  Created by Mu Young Ko on 2021/04/16.
//

#import "WildCardProgressBar.h"
#import "WildCardConstructor.h"
#import "JevilInstance.h"
#import "JevilCtx.h"
#import "WildCardUITapGestureRecognizer.h"

@interface WildCardProgressBar ()

@property float startX;
@property float startY;
@property float startObjectX;
@property float startObjectY;
@property NSTimeInterval downtime;
@property (nonatomic, retain) WildCardUITapGestureRecognizer* singleFingerTap;

@end

@implementation WildCardProgressBar

-(void)rateToView:(int)rate {
    if(self.vertical) {
        __block float barBgWidth = self.bar_bg.frame.size.height;
        float newBarWidth = barBgWidth*rate/100.0f;
        self.bar.frame = CGRectMake(self.bar_bg.frame.origin.x,
                                    self.bar_bg.frame.origin.y + (barBgWidth-newBarWidth),
                                    self.bar_bg.frame.size.width,
                                    newBarWidth);
        if(self.cap) {
            self.cap.center = CGPointMake(self.cap.center.x,
                                          self.bar_bg.frame.origin.y + (barBgWidth-newBarWidth));
        }
    } else {
        __block float barBgWidth = self.bar_bg.frame.size.width;
        float newBarWidth = barBgWidth*rate/100.0f;
        self.bar.frame = CGRectMake(self.bar.frame.origin.x, self.bar.frame.origin.y,
                                            newBarWidth, self.bar.frame.size.height);
        if(self.cap) {
            self.cap.center = CGPointMake(self.bar_bg.frame.origin.x +
                                         barBgWidth*rate/100.0f, self.cap.center.y);
        }
    }
    
}

-(void)click:(WildCardUITapGestureRecognizer *)recognizer {
    CGPoint xy = [recognizer locationOfTouch:0 inView:self.progressGroup];
    
    float barBgWidth = self.bar_bg.frame.size.width;
    float barBgLeft = self.bar_bg.frame.origin.x;
    float newBarWidth = xy.x - barBgLeft;
    __block float newRate = newBarWidth / (barBgWidth - barBgLeft) * 100;
    self.meta.correspondData[self.watch] = [NSNumber numberWithInt:(int)(newRate)];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        __block float barBgWidth = self.bar_bg.frame.size.width;
        float newBarWidth = barBgWidth*newRate/100.0f;
        self.bar.frame = CGRectMake(self.bar.frame.origin.x, self.bar.frame.origin.y,
                                            newBarWidth, self.bar.frame.size.height);
        if(self.cap) {
            self.cap.center = CGPointMake(self.bar_bg.frame.origin.x +
                                         barBgWidth*newRate/100.0f, self.cap.center.y);
        }
    } completion:NULL];
}

-(void)construct{
    if(self.dragable) {
        self.moving = NO;
        self.progressGroup.userInteractionEnabled = YES;
        self.bar.userInteractionEnabled = NO;
        [WildCardConstructor userInteractionEnableToParentPath:self.progressGroup depth:5];
        
        WildCardUITapGestureRecognizer *singleFingerTap =
        [[WildCardUITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.progressGroup addGestureRecognizer:singleFingerTap];
        self.singleFingerTap = singleFingerTap;
        
        [self.progressGroup addTouchCallback:^(int action, CGPoint p) {
            float newBarWidth = self.startObjectX-(self.startX-p.x);
            float barBgWidth = self.bar_bg.frame.size.width;
            float barBgLeft = self.bar_bg.frame.origin.x;
            if(action == TOUCH_ACTION_DOWN) {
                self.startX = p.x;
                self.startY = p.y;
                self.startObjectX = self.bar.frame.size.width;
                self.startObjectY = self.bar_bg.frame.size.height - self.bar.frame.size.height;
                self.moving = YES;
                self.downtime = [NSDate date].timeIntervalSince1970;
            } else if(action == TOUCH_ACTION_MOVE) {
                if(self.vertical) {
                    newBarWidth = self.startObjectY-(self.startY-p.y);
                    barBgWidth = self.bar_bg.frame.size.height;
                }
                
                if(newBarWidth < 0)
                    newBarWidth = 0;
                if(newBarWidth > barBgWidth)
                    newBarWidth = barBgWidth;
                float rate = newBarWidth / barBgWidth;
                if(self.vertical)
                    rate = 1.0f - newBarWidth / barBgWidth;
                
                [self rateToView:(int)(rate * 100)];
                self.meta.correspondData[self.watch] = [NSNumber numberWithInt:(int)(rate * 100)];
                NSLog(@"rate %f", rate);
                //NSLog(@"barBg.startObjectX %f", barBg.startObjectX);
                //NSLog(@"newBarWidth - %f" , newBarWidth);
                
                if(self.moveScript) {
                    JevilCtx* jevil = [JevilInstance currentInstance].jevil;
                    [jevil code:self.moveScript viewController:
                    [JevilInstance currentInstance].vc data:self.meta.correspondData meta:self.meta];
                }
                
            } else if(action == TOUCH_ACTION_UP || action == TOUCH_ACTION_CANCEL) {
                self.moving = NO;
                NSTimeInterval now = [NSDate date].timeIntervalSince1970;
                if(now - self.downtime < 0.1f) {
//                    __block float newRate = (self.startX - barBgLeft) / (barBgWidth - barBgLeft) * 100;
//                    self.meta.correspondData[self.watch] = [NSNumber numberWithInt:(int)(newRate)];
//                    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                        __block float barBgWidth = self.bar_bg.frame.size.width;
//                        float newBarWidth = barBgWidth*newRate/100.0f;
//                        self.bar.frame = CGRectMake(self.bar.frame.origin.x, self.bar.frame.origin.y,
//                                                            newBarWidth, self.bar.frame.size.height);
//                        if(self.cap) {
//                            self.cap.center = CGPointMake(self.bar_bg.frame.origin.x +
//                                                         barBgWidth*newRate/100.0f, self.cap.center.y);
//                        }
//                    } completion:NULL];
                }
                else if(self.dragUpScript) {
                    JevilCtx* jevil = [JevilInstance currentInstance].jevil;
                    [jevil code:self.dragUpScript viewController:
                    [JevilInstance currentInstance].vc data:self.meta.correspondData meta:self.meta];
                }
            }
        }];
    }
}

-(void)update {
    int rate  = [self.meta.correspondData[self.watch] intValue];
    [self rateToView:rate];
}

@end
