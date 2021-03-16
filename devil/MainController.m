//
//  MainController.m
//  CloudJsonViewer
//
//  Created by Mu Young Ko on 2020/11/13.
//  Copyright © 2020 Mu Young Ko. All rights reserved.
//

#import "MainController.h"
#import "Devil.h"
#import "Lang.h"

@interface MainController()

@end
@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationBar];
    self.title = trans(@"프로젝트 목록");
    
    [self constructRightBackButton:@"refresh.png"];
    
    [self update];
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    NSLog(@"locationManagerDidChangeAuthorization");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xffffff)];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [WildCardConstructor sharedInstance:@"1605234988599"];
}


- (void)showNavigationBar{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)rightClick:(id)sender{
    [self update];
}

-(void)update{
    [self showIndicator];
    [[Devil sharedInstance] request:@"/front/api/project" postParam:nil complete:^(id  _Nonnull res) {
       [self hideIndicator];
       self.data[@"list"] = res[@"list"];
       [self constructBlockUnder:@"1605324337776"]; 
    }];
}

-(BOOL)onInstanceCustomAction:(WildCardMeta *)meta function:(NSString*)functionName args:(NSArray*)args view:(WildCardUIView*) node{
    if([functionName isEqualToString:@"start"]){
        [self showIndicator];
        NSString* project_id = [NSString stringWithFormat:@"%@", meta.correspondData[@"id"]];
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [WildCardConstructor sharedInstance:project_id].delegate = appDelegate;
        [WildCardConstructor sharedInstance:project_id].textConvertDelegate = appDelegate;
        [WildCardConstructor sharedInstance:project_id].textTransDelegate = appDelegate;
        [DevilSdk start:project_id viewController:self complete:^(BOOL res) {
            [self hideIndicator];
        }];
        return true;
    }
    else 
        return [super onInstanceCustomAction:meta function:functionName args:args view:node];
}
@end
