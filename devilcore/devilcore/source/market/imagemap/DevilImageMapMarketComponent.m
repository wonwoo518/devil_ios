//
//  DevilImageMapMarketComponent.m
//  devilcore
//
//  Created by Mu Young Ko on 2022/08/10.
//

#import "DevilImageMapMarketComponent.h"
#import "MappingSyntaxInterpreter.h"
#import "DevilImageMap.h"
#import "WildCardConstructor.h"

@interface DevilImageMapMarketComponent()
@property (nonatomic, retain) DevilImageMap* v;
@end

@implementation DevilImageMapMarketComponent

- (void)initialized {
    [super initialized];
    self.v = [[DevilImageMap alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [self.v construct];
    [self.vv addSubview:self.v];
    [WildCardConstructor followSizeFromFather:self.vv child:self.v];
}

- (void)created {
    [super created];
    self.vv.userInteractionEnabled = YES;
    [WildCardConstructor userInteractionEnableToParentPath:self.vv depth:10];
}

- (void)update:(id)opt {
    [super update:opt];
    NSString* imageContent = self.marketJson[@"select2"];
    NSString* pinListJasonPath = self.marketJson[@"select3"];
    NSString* url = [MappingSyntaxInterpreter interpret:imageContent :opt];
    id pinList = [MappingSyntaxInterpreter getJsonWithPath:opt :pinListJasonPath];
    if(url && ![url isEqualToString:self.v.currentUrl]) {
        [self.v showImage:url];
    }
    self.v.pinList = pinList;
    self.v.currentUrl = url;
    [self.v syncPin];
}

@end