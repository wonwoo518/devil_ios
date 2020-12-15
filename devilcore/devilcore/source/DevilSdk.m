//
//  DevilSdk.m
//  devilcore
//
//  Created by Mu Young Ko on 2020/11/22.
//

#import "DevilSdk.h"
#import "devilcore.h"

@implementation DevilSdk

+(DevilSdk*)sharedInstance{
    static DevilSdk *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DevilSdk alloc] init];
    });
    return sharedInstance;
}

+(void)start:(NSString*)project_id viewController:(UIViewController*)vc complete:(void (^)(BOOL res))callback{
    [[WildCardConstructor sharedInstance:project_id] initWithOnlineOnComplete:^(BOOL success) {
        DevilController* d = [[DevilController alloc] init];
        NSString* firstScreenId = [[WildCardConstructor sharedInstance] getFirstScreenId];
        d.screenId = firstScreenId; 
        [vc.navigationController pushViewController:d animated:YES];
        callback(success);
    }];
}

@end
