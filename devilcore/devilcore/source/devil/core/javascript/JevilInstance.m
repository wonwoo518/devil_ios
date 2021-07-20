//
//  JevilInstance.m
//  devilcore
//
//  Created by Mu Young Ko on 2021/01/14.
//

#import "JevilInstance.h"
#import "JevilUtil.h"
#import "WildCardVideoView.h"

@implementation JevilInstance

+(JevilInstance*)globalInstance{
    static JevilInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JevilInstance alloc] init];
    });
    return sharedInstance;
}

+(JevilInstance*)screenInstance{
    static JevilInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JevilInstance alloc] init];
    });
    return sharedInstance;
}

+(JevilInstance*)currentInstance{
    static JevilInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JevilInstance alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.forRetain = [@{} mutableCopy];
    }
    return self;
}
-(void)syncData{
    JSValue* dataJs = [self.jscontext evaluateScript:@"data"];
    id newData = [dataJs toDictionary];
    [JevilUtil sync:newData :self.data];
}

-(void)pushData{
    self.jscontext[@"data"] = self.data;
}

-(void)videoViewAutoPlay{
    [WildCardVideoView autoPlay];
}

-(void)timerFunction:(NSString*)key{
    if(self.timerCallback != nil){
        self.timerCallback(key);
        self.timerCallback = nil;
    }
}
@end
