//
//  DevilImageMap.m
//  devilcore
//
//  Created by Mu Young Ko on 2022/08/10.
//

#import "DevilImageMap.h"
#import "WildCardConstructor.h"
#import "DevilUtil.h"
#import "WildCardUtil.h"
#import "DevilPinLayer.h"

#include <math.h>

@interface DevilImageMap()<UIScrollViewDelegate>
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UITapGestureRecognizer * singleFingerTap;
@property (nonatomic, retain) NSString* mode;
@property (nonatomic, retain) id param;
@property (nonatomic, retain) id editingPin;
@property (nonatomic, retain) id insertingPin;
@property (nonatomic, retain) id touchingPin;
@property (nonatomic, retain) DevilPinLayer* pinLayer;

@property BOOL shouldDirectionMove;

@property (nonatomic, retain) UIView* popupView;


@property void (^pinCallback)(id res);
@property void (^directionCallback)(id res);
@property void (^completeCallback)(id res);
@property void (^actionCallback)(id res);
@property void (^clickCallback)(id res);


@end

@implementation DevilImageMap

float circleWidth = 70;
float borderWidth = 7;

-(void)construct {
    float sw = [UIScreen mainScreen].bounds.size.width;
    float sh = [UIScreen mainScreen].bounds.size.height;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = NO;
    
    self.pinLayer = [[DevilPinLayer alloc] initWithFrame:CGRectMake(0, 0, sw, sh)];
    self.pinLayer.backgroundColor = [UIColor clearColor];
    self.pinLayer.userInteractionEnabled = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, sw, sh)];
    self.scrollView.bounces = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.autoresizesSubviews = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;

    self.scrollView.maximumZoomScale = 1;
    _scrollView.delegate = self;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw, sh)];
    _contentView.userInteractionEnabled = NO;
    
    [self addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    [_contentView addSubview:_imageView];
    [_contentView addSubview:_pinLayer];
    [WildCardConstructor followSizeFromFather:self child:self.scrollView];
    
    _singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickListener:)];
    [self addGestureRecognizer:_singleFingerTap];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    self.mode = @"normal";
}

-(CGPoint) pinToScreenPoint:(id)pin {
    UIView* rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    float x = [pin[@"x"] floatValue];
    float y = [pin[@"y"] floatValue];
    CGPoint pinPointInScreen = [_contentView convertPoint:CGPointMake(x, y) toView:rootView];
    return pinPointInScreen;
}

-(BOOL) isNearPin:(id)pin tap:(CGPoint)tappedPoint {
    UIView* rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    float x = [pin[@"x"] floatValue];
    float y = [pin[@"y"] floatValue];
    CGPoint pinPointInScreen = [_contentView convertPoint:CGPointMake(x, y) toView:rootView];
    float w = 40;
    CGRect pinRect = CGRectMake(pinPointInScreen.x -w/2, pinPointInScreen.y-w/2, w, w);
    return CGRectContainsPoint(pinRect, tappedPoint);
}

-(void)onClickListener:(UIGestureRecognizer *)recognizer {
//    NSLog(@"onClickListener");
    CGPoint tappedPoint = [recognizer locationInView:self];
    if([@"normal" isEqualToString:self.mode]) {
        for(id pin in self.pinList) {
            if([self isNearPin:pin tap:tappedPoint]) {
                if(self.clickCallback){
                    self.clickCallback([@{@"key":pin[@"key"]} mutableCopy]);
                    return;
                }
            }
        }
        
        if(self.clickCallback)
            self.clickCallback([@{} mutableCopy]);
    } else if([@"new" isEqualToString:self.mode]) {
        CGPoint mp = [self clickToMapPoint:tappedPoint];
        BOOL inMap = CGRectContainsPoint([WildCardUtil getGlobalFrame:self.contentView], tappedPoint);
        if(inMap) {
            id p = [@{} mutableCopy];
            p[@"x"] = [NSNumber numberWithFloat:mp.x];
            p[@"y"] = [NSNumber numberWithFloat:mp.y];
            p[@"key"] = @"10000";
            p[@"text"] = [NSString stringWithFormat:@"%lu", [self.pinList count]+1];
            if(self.param && self.param[@"text"])
                p[@"text"] = self.param[@"text"];

            if(self.param[@"color"])
                p[@"color"] = self.param[@"color"];
            else
                p[@"color"] = @"#90ff0000";
            
            p[@"degree"] = @0;
            p[@"hideDirection"] = @TRUE;
            self.insertingPin = p;
            
            [self syncPin];
            
            [self setMode:@"new_direction" : nil];
            [self showPopup:@[@"취소"]];
            
            if(self.pinCallback)
                self.pinCallback([@{@"mode":self.mode} mutableCopy]);
        }
        
    } else if([@"edit" isEqualToString:self.mode]) {
        
        CGPoint mp = [self clickToMapPoint:tappedPoint];
        BOOL inMap = CGRectContainsPoint([WildCardUtil getGlobalFrame:self.contentView], tappedPoint);
        if(inMap) {
            self.editingPin[@"x"] = [NSNumber numberWithFloat:mp.x];
            self.editingPin[@"y"] = [NSNumber numberWithFloat:mp.y];
        }
        
        [self syncPin];
        
        [self setMode:@"new_direction" : nil];
        [self showPopup:@[@"취소"]];
    } else if([self isPopupShow] && CGRectContainsPoint([WildCardUtil getGlobalFrame:self.popupView], tappedPoint)) {
        for(UILabel* c in [self.popupView subviews]) {
            if(CGRectContainsPoint([WildCardUtil getGlobalFrame:c], tappedPoint)) {
                [self hidePopup];
                if([@"취소" isEqualToString:c.text]) {
                    [self setMode:@"normal" : nil];
                } else if([@"완료" isEqualToString:c.text]) {
                    [self complete];
                }
                
                if(self.actionCallback)
                    self.actionCallback([@{
                        @"mode": self.mode,
                        @"key" : c.text,
                    } mutableCopy]);
            }
        }
    }
}

-(CGPoint)clickToMapPoint:(CGPoint)p {
    return [self convertPoint:p toView:self.contentView];
}

-(void)showImage:(NSString*)url{
    if([url hasPrefix:@"http"]) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:url];
        NSURLSessionDataTask* task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error) {
                
            } else {
                UIImage* image = [UIImage imageWithData:data];
                [self initializeWithImage:image];
            }
        }];
        [task resume];
    } else {
        NSString* path = [DevilUtil replaceUdidPrefixDir:url];
        NSData* mapData = [NSData dataWithContentsOfFile:path];
        UIImage* image = [UIImage imageWithData:mapData];
        [self initializeWithImage:image];
        
    }
    
}

-(void)initializeWithImage:(UIImage*) image {;
    [self.imageView setImage:image];
    //NSLog(@"%lu %f %f", (unsigned long)[mapData length] , image.size.width, image.size.height);
            
    _scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
    _pinLayer.frame = _contentView.frame = _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    //float sw = [UIScreen mainScreen].bounds.size.width;
    float width_scale = self.frame.size.width/image.size.width;
    float height_scale = self.frame.size.height/image.size.height;
    
    float scale = self.scrollView.minimumZoomScale = width_scale;
    float min_inset_width = self.frame.size.width*0.0f;
    float min_inset_height = self.frame.size.height*0.0f + ( (self.frame.size.height- image.size.height*width_scale) / 2);
    
    if((self.frame.size.width / self.frame.size.height) > (image.size.width / image.size.height)) {
        scale = self.scrollView.minimumZoomScale = height_scale;
        min_inset_width = self.frame.size.width*0.0f + ( (self.frame.size.width - image.size.width*height_scale) / 2);
        min_inset_height = self.frame.size.height*0.0f;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(min_inset_height, min_inset_width, min_inset_height, min_inset_width);
    self.scrollView.contentOffset = CGPointMake(image.size.width/2*scale, image.size.height/2*scale);
    self.scrollView.zoomScale = scale;
    
    self.pinLayer.zoomScale = scale;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint clickP = point;
    if([self.mode isEqualToString:@"new_direction"] || [self.mode isEqualToString:@"can_complete"]) {
        if(_editingPin) {
            self.touchingPin = _editingPin;
        } else {
            self.touchingPin = _insertingPin;
        }
        
        if([self isNearPin:self.touchingPin tap:clickP]) {
            self.shouldDirectionMove = YES;
            self.touchingPin[@"hideDirection"] = @FALSE;
            return self;
        }
    }
    
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint clickP = [touch locationInView:self];
    if([self.mode isEqualToString:@"new_direction"] || [self.mode isEqualToString:@"can_complete"]) {
        if(_editingPin) {
            self.touchingPin = _editingPin;
        } else {
            self.touchingPin = _insertingPin;
        }
        
        if([self isNearPin:_insertingPin tap:clickP]) {
            self.shouldDirectionMove = YES;
            self.touchingPin[@"hideDirection"] = @FALSE;
        }
    }
}

    
- (float)distance:(CGPoint)a : (CGPoint)b {
    return sqrt(pow((a.x - b.x), 2) + pow((a.y - b.y), 2));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint clickP = [touch locationInView:self];
    if(self.shouldDirectionMove && ([self.mode isEqualToString:@"new_direction"] || [self.mode isEqualToString:@"can_complete"])) {
        [self pinDirection:self.touchingPin :clickP];
    }
}

- (void)pinDirection:(id)pin :(CGPoint)see {
    CGPoint pinScreenPoint = [self pinToScreenPoint:pin];
    double r = atan2(see.y - pinScreenPoint.y, see.x - pinScreenPoint.x);
    double degree = r * 180 / M_PI  + 90;
    //NSLog(@"degree - %f", degree);
    pin[@"degree"] = [NSNumber numberWithInt:(int)degree];
    [_pinLayer updatePinDirection:pin[@"key"]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint clickP = [touch locationInView:self];
    if([self.mode isEqualToString:@"new_direction"] || [self.mode isEqualToString:@"can_complete"]) {
        [self setMode:@"can_complete" : nil];
        self.shouldDirectionMove = false;
        [self hidePopup];
        [self showPopup:@[@"취소", @"완료"]];
        if (self.directionCallback)
            self.directionCallback([@{@"mode":self.mode} mutableCopy]);
    }
}


-(void)syncPin {
    id children = [self.contentView subviews];
    for(id child in children) {
        if(child != self.imageView && child != self.popupView  && child != _pinLayer)
           [child removeFromSuperview];
    }
    
    _pinLayer.pinList = [self.pinList mutableCopy];
    if(self.insertingPin)
        [_pinLayer.pinList addObject:self.insertingPin];
    
    [_pinLayer setNeedsDisplay];
    [_pinLayer syncPin];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll");
    [self updatePopupPoint];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDragging");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidZoom %f", scrollView.zoomScale);
    
    [_pinLayer updateZoom:scrollView.zoomScale];
//    _pinLayer.zoomScale = scrollView.zoomScale;
//    [_pinLayer setNeedsDisplay];
    
    float z = scrollView.zoomScale;
    id children = [self.contentView subviews];
    int index = 0;
    for(id child in children) {
        if(child != self.imageView && child != self.popupView  && child != _pinLayer) {
            id pin;
            if(index < [self.pinList count])
                pin = self.pinList[index];
            else
                pin = self.insertingPin;
                
            UIView* pv = child;
            CGPoint p = pv.center;
            pv.frame = CGRectMake(0, 0, circleWidth / z, circleWidth / z);
            pv.center = p;
            
            UIImageView* pi = [pv viewWithTag:4421];
            float angle = [pin[@"degree"] floatValue];
            float radians = angle / 180.0 * M_PI;
            pi.layer.anchorPoint = CGPointMake(0.5, 0.5);
            pi.transform = CGAffineTransformMakeRotation(0);
            pi.frame = CGRectMake(0, 0, circleWidth/z, circleWidth/z);
            pi.transform = CGAffineTransformMakeRotation(radians);
            
            UILabel* text = [pv viewWithTag:4425];
            text.frame = CGRectMake(0, 0, circleWidth/z, circleWidth/z);
            text.transform = CGAffineTransformMakeScale(1.0f/z, 1.0f/z);
            
            index ++;
        }
    }
    
    [self updatePopupPoint];
}

- (void)callback:(NSString*)command :(void (^)(id res))callback{
    if([command isEqualToString:@"pin"])
        self.pinCallback = callback;
    else if([command isEqualToString:@"direction"])
        self.directionCallback = callback;
    else if([command isEqualToString:@"complete"])
        self.completeCallback = callback;
    else if([command isEqualToString:@"action"])
        self.actionCallback = callback;
    else if([command isEqualToString:@"click"])
        self.clickCallback = callback;
}

- (void)relocation:(NSString*)key {
    for(id pin in self.pinList) {
        if([key isEqualToString:pin[@"key"]]) {
            self.editingPin = pin;
            [self setMode:@"edit": nil];
            break;
        }
    }
}

- (void)setMode:(NSString*)mode :(id)param {
    if([@"normal" isEqualToString:mode]) {
        self.editingPin = self.insertingPin = nil;
    }
    self.mode = mode;
    self.param = param;
}

- (void)complete {
    if(self.insertingPin) {
        id pin = self.insertingPin;
        [self hidePopup];
        _insertingPin = nil;
        [self setMode:@"normal" : nil];
        if(self.completeCallback)
            self.completeCallback([@{
                @"list":self.pinList,
                @"type":@"new",
                @"pin":pin,
            } mutableCopy]);
    } else if (self.editingPin) {
        id pin = self.editingPin;
        self.editingPin = nil;
        [self hidePopup];
        [self setMode:@"normal":nil];
        if(self.completeCallback)
            self.completeCallback([@{
                @"list":self.pinList,
                @"type":@"edit",
                @"pin":pin,
            } mutableCopy]);
    }
}

-(void)hidePopup {
    [self.popupView removeFromSuperview];
    self.popupView = nil;
}

-(CGPoint)centerOfRect:(CGRect)rect {
    float x = rect.origin.x + rect.size.width/2;
    float y = rect.origin.y + rect.size.height/2;
    return CGPointMake(x, y);
}

-(void)updatePopupPoint {
    if(self.popupView) {
        
        CGPoint screenPoint;
        if(_insertingPin) {
            screenPoint = [self pinToScreenPoint:_insertingPin];
        } else if(_editingPin) {
            screenPoint = [self pinToScreenPoint:_editingPin];
        }
            
        float pw = 90;
        float ph = 50;
        float gap = 30;
        float x = screenPoint.x + gap;
        float y = screenPoint.y;
        float sw = [UIScreen mainScreen].bounds.size.width;
//        if(x > sw - pw)
//            x = screenPoint.x - pw - gap;
        self.popupView.frame = CGRectMake(x, y, self.popupView.frame.size.width, self.popupView.frame.size.height);
    }
}
-(void)showPopup:(id)selection {
    float pw = 90;
    float ph = 50;
    float gap = 30;
    
    UIView* popup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pw, ph * [selection count] )];
    popup.backgroundColor = [UIColor whiteColor];
    popup.layer.cornerRadius = 5;
    popup.layer.shadowOffset = CGSizeMake(5, 5);
    popup.layer.shadowRadius = 5;
    popup.layer.shadowOpacity = [WildCardUtil alphaWithHexString:@"#90000000"];
    popup.layer.shadowColor = [WildCardUtil colorWithHexString:@"#90000000"].CGColor;
    
    int index = 0;
    for(NSString* s in selection) {
        UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(0, index*ph, pw, ph)];
        text.font = [UIFont boldSystemFontOfSize:20];
        text.textColor = [WildCardUtil colorWithHexString:@"#333333"];
        text.text = s;
        text.textAlignment = NSTextAlignmentCenter;
        [popup addSubview:text];
        index ++;
    }
    [self addSubview:popup];
    self.popupView = popup;
    [self updatePopupPoint];
}

-(BOOL)isPopupShow {
    return self.popupView != nil;
}
@end
