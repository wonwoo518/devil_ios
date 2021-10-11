//
//  DevilController.m
//  devilcore
//
//  Created by Mu Young Ko on 2020/12/04.
//

#import "DevilController.h"
#import "devilcore.h"
#import "JevilInstance.h"
#import "DevilExceptionHandler.h"
#import "DevilDebugView.h"
#import "Lottie.h"
#import "JevilCtx.h"
#import "DevilSound.h"
#import "DevilDrawer.h"

@interface DevilController ()

@property (nonatomic, retain) DevilHeader* header;
@property (nonatomic, retain) JevilCtx* jevil;
@property int header_sketch_height;
@property BOOL hasOnResume;
@property BOOL hasOnFinish;
@property BOOL hasOnCreated;
@property (nonatomic, retain) id thisMetas;
@end




@implementation DevilController

- (void)viewDidLoad{   
    [super viewDidLoad];
    if(self.projectId){
        [WildCardConstructor sharedInstance:self.projectId];
    }
    
    self.jevil = [[JevilCtx alloc] init];
    self.thisMetas = [@{} mutableCopy];
    
    _viewExtend = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
    _viewExtend.userInteractionEnabled = YES;
    [self.view addSubview:_viewExtend];
    
    _viewMain = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
    _viewMain.userInteractionEnabled = YES;
    [self.view addSubview:_viewMain];
    
    if(self.startData) {
        self.data = self.startData;
    } else
        self.data = [@{} mutableCopy];
    self.offsetY = self.navigationController.navigationBar.frame.size.height 
        + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.viewHeight = screenHeight - self.offsetY;
    self.viewMain.frame = CGRectMake(0, self.offsetY, screenWidth, _viewHeight);
    
    NSString* common_javascript = [WildCardConstructor sharedInstance].project[@"common_javascript"];
    NSString* declared =[[WildCardConstructor sharedInstance] getDeclaredCode];
    common_javascript = [common_javascript stringByAppendingString:declared];
    NSString* embed_code =[WildCardConstructor sharedInstance].project[@"embed_code"];
    common_javascript = [common_javascript stringByAppendingString:embed_code];
    if(common_javascript != nil && common_javascript != [NSNull null])
        [self.jevil code:common_javascript viewController:self data:self.data meta:nil];
    
    id screen = [[WildCardConstructor sharedInstance] getScreen:self.screenId];
    [self updateHasFunction];

    [self constructHeaderAndFooter];

    [self construct];
    
    [JevilInstance globalInstance].callbackData = nil;
    [JevilInstance globalInstance].callbackFunction = nil;
    [DevilDebugView constructDebugViewIf:self];
}

-(void)updateHasFunction {
    self.hasOnCreated = self.hasOnFinish = self.hasOnResume = false;
    id screen = [[WildCardConstructor sharedInstance] getScreen:self.screenId];
    self.screenName = screen[@"name"];
    self.projectId = screen[@"project_id"];
    if(screen[@"javascript_on_create"]){
        NSString* code = screen[@"javascript_on_create"];
        
        if([code rangeOfString:@"function onCreated"].length > 0)
            self.hasOnCreated = true;
        if([code rangeOfString:@"function onResume"].length > 0)
            self.hasOnResume = true;
        if([code rangeOfString:@"function onFinish"].length > 0)
            self.hasOnFinish = true;
        [WildCardConstructor sharedInstance].loadingDelegate = self;
        [self.jevil code:code viewController:self data:self.data meta:nil];
    }
}
-(void)constructHeaderAndFooter{
    if([[WildCardConstructor sharedInstance] getHeaderCloudJson:self.screenId]){
        id headerCloudJson = [[WildCardConstructor sharedInstance] getHeaderCloudJson:self.screenId];
        self.header = [[DevilHeader alloc] initWithViewController:self layer:headerCloudJson withData:self.data instanceDelegate:self];
        float a = self.navigationController.navigationBar.frame.size.height;
        _header_sketch_height = [WildCardUtil headerHeightInSketch];
    } else
        [self hideNavigationBar];
    
    CGFloat topPadding = 0;
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        topPadding = window.safeAreaInsets.top;
        bottomPadding = window.safeAreaInsets.bottom;
    }
    
    id footer = [[WildCardConstructor sharedInstance] getFooterCloudJson:self.screenId];
    if(footer){
        id footerCloudJson = footer[@"cloudJson"];
        self.fix_footer = [footer[@"fix_footer"] boolValue];
        self.footer = [WildCardConstructor constructLayer:nil withLayer:footerCloudJson instanceDelegate:self];
        self.original_footer_height = self.footer.frame.size.height;
        
        [WildCardConstructor applyRule:self.footer withData:self.data];
        
        int footerY = screenHeight - self.footer.frame.size.height - bottomPadding;
        self.original_footer_height_plus_bottom_padding = self.footer.frame.size.height + bottomPadding;
        self.footer.frame= CGRectMake(0, footerY, self.footer.frame.size.width,
                                      self.original_footer_height_plus_bottom_padding + 1);//푸터 하단에 0.x픽셀정도 구멍뚤릴때가 있음
        self.original_footer_y = footerY;
        
        self.footer_sketch_height = [footerCloudJson[@"frame"][@"h"] intValue] +
            [WildCardUtil convertPixcelToSketch:bottomPadding ];
        
        [self.view addSubview:self.footer];
    }
    
    id inside_footer = [[WildCardConstructor sharedInstance] getInsideFooterCloudJson:self.screenId];
    if(inside_footer) {
        self.inside_footer = [WildCardConstructor constructLayer:nil withLayer:inside_footer instanceDelegate:self];
        [WildCardConstructor applyRule:self.inside_footer withData:self.data];
        
        float inside_footer_y = (float)screenHeight - self.inside_footer.frame.size.height
            - (self.footer?self.footer.frame.size.height:0);
        self.inside_footer.frame = CGRectMake(0, inside_footer_y, self.inside_footer.frame.size.width,
                                              self.inside_footer.frame.size.height);
        
        [self.view addSubview:self.inside_footer];
    }
    
    [[WildCardConstructor sharedInstance] firstBlockFitScreenIfTrue:self.screenId sketch_height_more:_header_sketch_height + self.footer_sketch_height];
}

-(void)tab:(NSString*)screenId {
    if(self.tv)
        [self.tv removeFromSuperview];
    if(self.mainWc)
        [self.mainWc removeFromSuperview];
    
    self.jevil = [[JevilCtx alloc] init];
    if(self.startData) {
        self.data = self.startData;
    } else
        self.data = [@{} mutableCopy];
    
    NSString* common_javascript =[WildCardConstructor sharedInstance].project[@"common_javascript"];
    NSString* declared =[[WildCardConstructor sharedInstance] getDeclaredCode];
    common_javascript = [common_javascript stringByAppendingString:declared];
    NSString* embed_code =[WildCardConstructor sharedInstance].project[@"embed_code"];
    common_javascript = [common_javascript stringByAppendingString:embed_code];
    
    if(common_javascript != nil && common_javascript != [NSNull null])
        [self.jevil code:common_javascript viewController:self data:self.data meta:nil];
    
    self.screenId = screenId;
    id screen = [[WildCardConstructor sharedInstance] getScreen:self.screenId];
    [self updateHasFunction];

    id footer = [[WildCardConstructor sharedInstance] getFooterCloudJson:self.screenId];
    if(footer)
        self.fix_footer = [footer[@"fix_footer"] boolValue];
    [WildCardConstructor applyRule:self.footer withData:self.data];

    [[WildCardConstructor sharedInstance] firstBlockFitScreenIfTrue:self.screenId sketch_height_more:_header_sketch_height + self.footer_sketch_height];
    [self construct];
    [self onResume];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkHeader];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkHeader];
    
    [WildCardConstructor sharedInstance].loadingDelegate = self;
    
    if([JevilInstance globalInstance].callbackData){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[JevilInstance globalInstance].callbackData
                                                           options:nil
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [JevilInstance globalInstance].callbackData = nil;
        [self.jevil code:[NSString stringWithFormat:@"callback(%@)", jsonString] viewController:self data:self.data meta:nil];
    } else if([JevilInstance globalInstance].callbackFunction){
        JSValue* c = [JevilInstance globalInstance].callbackFunction;
        [JevilInstance globalInstance].callbackFunction = nil;
        NSString* acode = [NSString stringWithFormat:@"var a = %@()", c];
        [self.jevil code:acode viewController:self data:self.data meta:nil];
    }
    
    [JevilInstance currentInstance].vc = self;
    
    [[DevilDrawer sharedInstance] show:self];
    
    [self performSelector:@selector(onResume) withObject:nil afterDelay:0.01f];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.wifiManager)
        [self.wifiManager dismiss];
    [[DevilSound sharedInstance] setTickCallback:nil];
    [[DevilDrawer sharedInstance] hide:self];
    
    for(NSString* key in [self.thisMetas allKeys])
        [self.thisMetas[key] paused];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    if(![self.navigationController.viewControllers containsObject:self]) {
        [self finish];
        
        for(NSString* key in [self.thisMetas allKeys])
            [self.thisMetas[key] destory];
    }
    
    [super viewDidDisappear:animated];
}

-(void)onCreated {
    if(self.hasOnCreated && self.navigationController.topViewController == self){
        [self.jevil code:@"onCreated()" viewController:self data:self.data meta:nil];
    }
}

-(void)onResume {
    for(NSString* key in [self.thisMetas allKeys])
        [self.thisMetas[key] resumed];
    
    if(self.hasOnResume && self.navigationController.topViewController == self){
        [self.jevil code:@"onResume()" viewController:self data:self.data meta:nil];
    }
}

- (void)startLoading{
    [self showIndicator];
}

- (void)stopLoading{
    [self hideIndicator];
}

- (void)checkHeader{
    if([[WildCardConstructor sharedInstance] getHeaderCloudJson:self.screenId]){
        [self showNavigationBar];
    }else
        [self hideNavigationBar];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[WildCardConstructor sharedInstance].project[@"status_bar_style_light_content"] boolValue])
        return UIStatusBarStyleLightContent;
    else
        return UIStatusBarStyleDarkContent;
}

- (void)showNavigationBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.offsetY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.viewHeight = screenHeight - self.offsetY;
    self.viewMain.frame = CGRectMake(0, self.offsetY, screenWidth, _viewHeight);
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)hideNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.offsetY = 0;
    self.viewHeight = screenHeight - self.offsetY;
    self.viewMain.frame = CGRectMake(0, self.offsetY, screenWidth, _viewHeight);
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)construct {
    id list = [WildCardConstructor sharedInstance].screenMap[self.screenId][@"list"];
    if([list count] > 1 || ![list[0][@"type"] isEqualToString:@"sketch"])
        [self createWildCardScreenListView:self.screenId];
    else if([[WildCardConstructor sharedInstance] isFirstBlockFitScreen:self.screenId]) {
        [self constructBlockUnder:[[WildCardConstructor sharedInstance] getFirstBlock:self.screenId]];
        _mainWc.meta.jevil = self.jevil;
        [_mainWc.meta created];
        [self onCreated];
    } else {
        //[self createWildCardScreenListView:self.screenId];
        [self constructBlockUnderScrollView:[[WildCardConstructor sharedInstance] getFirstBlock:self.screenId]];
        _mainWc.meta.jevil = self.jevil;
        [_mainWc.meta created];
        [self onCreated];
    }
}

- (void)releaseScreen {
    if(self.mainWc != nil) {
        [self.mainWc removeFromSuperview];
        self.mainWc = nil;
    }
    if(self.scrollView != nil) {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    if(self.tv != nil) {
        [self.tv removeFromSuperview];
        self.tv = nil;
    }
}

- (void)constructBlockUnder:(NSString*)block{
    [self releaseScreen];
    NSMutableDictionary* cj = [[WildCardConstructor sharedInstance] getBlockJson:block];
    self.mainWc = [WildCardConstructor constructLayer:self.viewMain withLayer:cj instanceDelegate:self];
    NSString* key = [NSString stringWithFormat:@"%@", self.mainWc.meta];
    self.thisMetas[key] = self.mainWc.meta;
    [WildCardConstructor applyRule:self.mainWc withData:_data];
}

- (void)constructBlockUnderScrollView:(NSString*)block{
    /**
     TODO : 스크롤뷰를 사용안하고 listview를 사용해도된다. 스크롤뷰를 사용하려면 푸터 해더 높이 반영해야한다
     */
    [self releaseScreen];
    if(self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
        [_viewMain addSubview:self.scrollView];
    }
    NSMutableDictionary* cj = [[WildCardConstructor sharedInstance] getBlockJson:block];
    self.mainWc = [WildCardConstructor constructLayer:self.scrollView withLayer:cj instanceDelegate:self];
    NSString* key = [NSString stringWithFormat:@"%@", self.mainWc.meta];
    self.thisMetas[key] = self.mainWc.meta;
    [WildCardConstructor applyRule:self.mainWc withData:_data];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    float toBeHeight = screenHeight;
    if(_header_sketch_height > 0)
        toBeHeight -= [WildCardUtil headerHeightInSketch];
    if(self.footer)
        toBeHeight -= self.original_footer_height_plus_bottom_padding;
    self.scrollView.frame = CGRectMake(0,0,screenWidth, toBeHeight);
    self.scrollView.contentSize = CGSizeMake(screenWidth, self.mainWc.frame.size.height);
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.scrollView.bounces = NO;
}

- (void)createWildCardScreenListView:(NSString*)screenId{
    [self releaseScreen];
    self.tv = [[WildCardScreenTableView alloc] initWithScreenId:screenId];
    self.tv.data = self.data;
    self.tv.wildCardConstructorInstanceDelegate = self;
    self.tv.tableViewDelegate = self;
    int footerHeight = self.original_footer_height_plus_bottom_padding;
    self.tv.frame =  CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height - footerHeight);
    [self.viewMain addSubview:self.tv];
}

- (void)cellUpdated:(int)index view:(WildCardUIView *)v{
    _mainWc = v;
    NSString* key = [NSString stringWithFormat:@"%@", v.meta];
    if(self.thisMetas[key] == nil) {
        v.meta.jevil = self.jevil;
        [v.meta created];
        if(index == 0)
            [self onCreated];
    }
    self.thisMetas[key] = v.meta;
}

-(BOOL)onInstanceCustomAction:(WildCardMeta *)meta function:(NSString*)functionName args:(NSArray*)args view:(WildCardUIView*) node{
    @try{
        if([functionName isEqualToString:@"Jevil.script"]){
            NSString* code = args[0];
            code = [code substringFromIndex:1];
            code = [code substringToIndex:[code length]-1];
            meta.lastClick = node;
            [self.jevil code:code viewController:self data:self.data meta:meta];
            return YES;
        } else if([functionName isEqualToString:@"script"]){
            NSString* code = args[0];
            meta.lastClick = node;
            [self.jevil code:code viewController:self data:self.data meta:meta];
            return YES;
        } else if([functionName hasPrefix:@"Jevil"]) {
            meta.lastClick = node;
            [JevilAction act:functionName args:args viewController:self meta:meta];
            return YES;
        }
    } @catch (NSException* e){
        [DevilExceptionHandler handle:self data:self.data e:e];
        NSLog(@"%@",e);
    }
     
    return NO;
}


-(void)updateMeta {
    if(self.tv != nil)
        [self.tv reloadData];
    else if(_mainWc != nil) {
        [_mainWc.meta update];
        if(self.scrollView) {
            self.scrollView.contentSize = CGSizeMake(screenWidth, self.mainWc.frame.size.height);
        }
    }
    
    if(self.header)
        [self.header update:self.data];
    [WildCardConstructor applyRule:self.footer withData:self.data];
    
    if(self.inside_footer)
        [WildCardConstructor applyRule:self.inside_footer withData:self.data];
    
    [[DevilDrawer sharedInstance] update:self];
}

-(void)finish {
    if(self.hasOnFinish){
        /**
         이 문제는 replaceScreen 혹은 rootScreen 에서 발생한다
         새로운 화면의 code가 실행되고, 나서야 이 코드가 실행되는데 이렇게 되면 [JevilInstance currentInstance].vc 가 self로 되어
         이미 죽은 viewController가 셋 된다 그래서 아래의 hide true하여
         죽어가는 meta, viewcontroler, data가 현행으로 세팅하는것을 방지해야한다
         */
        [self.jevil code:@"onFinish()" viewController:self data:self.data meta:nil hide:true];
    }
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller{
    
}

-(WildCardUIView*)findView:(NSString*) name {
    WildCardUIView* a = [self.mainWc.meta getView:name];
    if(a)
        return a;
    
    for(NSString* a in self.thisMetas) {
        WildCardUIView* r = (WildCardUIView*) [self.thisMetas[a] getView:name];
        if(r != nil)
            return r;
    }
    
    if(self.footer) {
        WildCardUIView* r = [self.footer.meta getView:name];
        if(r != nil)
            return r;
    }

    return nil;
}

@end
