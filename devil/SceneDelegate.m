//
//  SceneDelegate.m
//  test
//
//  Created by Mu Young Ko on 2022/09/16.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "FirstController.h"
#import "Devil.h"

@import devilcore;

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.window = [[UIWindow alloc] initWithWindowScene:scene];
    UIViewController* vc = [[FirstController alloc] initWithNibName:@"FirstController" bundle:nil];
    app.navigationController = [[DevilNavigationController alloc] initWithRootViewController:vc];
    app.window.rootViewController = app.navigationController;
    [app.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    AppDelegate* application = [UIApplication sharedApplication].delegate;
    UIViewController* top = [application.navigationController topViewController];
    if([top isKindOfClass:[DevilController class]])
        [((DevilController*)top) onResume];
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    
    AppDelegate* application = [UIApplication sharedApplication].delegate;
    if([application.navigationController.topViewController isKindOfClass:[DevilController class]]){
        DevilController* vc = (DevilController*)application.navigationController.topViewController;
        [vc onPause];
    }
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


- (void) scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    
    NSURL* url = [URLContexts anyObject].URL;
    [[Devil sharedInstance] openUrl:url];
}


@end
