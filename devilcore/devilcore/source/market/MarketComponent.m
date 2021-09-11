//
//  MarketComponent.m
//  devilcore
//
//  Created by Mu Young Ko on 2021/07/12.
//

#import "MarketComponent.h"
#import "JevilCtx.h"
#import "JevilInstance.h"

@implementation MarketComponent

-(id)initWithLayer:(id)market meta:(id)meta{
    self = [super init];
    self.marketJson = market;
    self.meta = meta;
    return self;
}

-(void)created{
    NSString* script = self.marketJson[@"created"];
    [self.meta.jevil code:script viewController:[JevilInstance currentInstance].vc data:self.meta.correspondData meta:self.meta];
}
-(void)update:(id)opt{
    self.meta.correspondData = opt;
}
-(void)pause{
    
}
-(void)resume{
    
}
-(void)destory {
    
}
@end
