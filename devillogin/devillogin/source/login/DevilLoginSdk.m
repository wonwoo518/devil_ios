//
//  DevilLoginSdk.m
//  devillogin
//
//  Created by Mu Young Ko on 2021/04/04.
//

#import "DevilLoginSdk.h"
#import "DevilFacebook.h"
#import "DevilGoogleLogin.h"
#import <devillogin/devillogin-Swift.h>
#import "JevilLogin.h"


@import devilcore;
@import FBSDKLoginKit;

@implementation DevilLoginSdk

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DevilSdk sharedInstance] addCustomJevil:[JevilLogin class]];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"devil" ofType:@"plist"];
    id devilConfig = [[NSDictionary alloc] initWithContentsOfFile:path];
    if(devilConfig[@"hasKakaoLogin"]){
        [DevilKakaoLogin initKakaoAppKey];
    }
    
    if(devilConfig[@"hasFacebookLogin"]){
        [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"devil" ofType:@"plist"];
    id devilConfig = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if(devilConfig[@"hasKakaoLogin"] && [DevilKakaoLogin handleOpenUrl:url])
        return true;
    
    if(devilConfig[@"hasFacebookLogin"] &&
       [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]])
        return true;
    
    
    if(devilConfig[@"hasGoogleLogin"] &&
       [DevilGoogleLogin application:application openURL:url options:options])
        return true;
    return false;
}

@end
