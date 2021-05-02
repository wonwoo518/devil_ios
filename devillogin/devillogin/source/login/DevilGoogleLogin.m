//
//  DevilGoogleLogin.m
//  devillogin
//
//  Created by Mu Young Ko on 2021/04/23.
//

#import "DevilGoogleLogin.h"


@implementation DevilGoogleLogin

+ (id)sharedInstance {
    static DevilGoogleLogin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)loginWithComplete:(UIViewController*)vc callback:(void (^)(id user))callback{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"devil" ofType:@"plist"];
    id devilConfig = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    [GIDSignIn sharedInstance].clientID = devilConfig[@"GoogleLoginClientId"];
    [GIDSignIn sharedInstance].delegate = [DevilGoogleLogin sharedInstance];
    self.callback = callback;
    [GIDSignIn sharedInstance].presentingViewController = vc;
    [[GIDSignIn sharedInstance] signIn];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return NO;
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if(user == nil){
        self.callback(nil);
        self.callback = nil;
    } else {
        NSString *userId = user.userID;                  // For client-side use only!
        __block NSString *token = user.authentication.idToken; // Safe to send to the server
        __block NSString *name = user.profile.name;
        NSString *email = user.profile.email;
        NSString *profile = nil;
        if([user.profile hasImage])
            profile = [[user.profile imageURLWithDimension:120] absoluteString];
        
        id r = [@{} mutableCopy];
        r[@"id"] = userId;
        r[@"name"] = name;
        r[@"profile"] = profile;
        r[@"email"] = email;
        r[@"token"] = token;
        r[@"gender"] = @"";
        r[@"age"] = @"";
        self.callback(r);
        self.callback = nil;
    }
}

@end