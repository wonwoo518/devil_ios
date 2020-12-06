//
//  ReplaceRuleRepeat.h
//  CloudJsonViewer
//
//  Created by Mu Young Ko on 2018. 6. 18..
//  Copyright © 2018년 Mu Young Ko. All rights reserved.
//

#import "ReplaceRule.h"

#define ReplaceRuleRepeat(replaceView, replaceJsonLayer, replaceJsonKey) [[ReplaceRuleRepeat alloc] initWith:replaceView:replaceJsonLayer:replaceJsonKey]



#define REPEAT_TYPE_RIGHT @"0"
#define REPEAT_TYPE_BOTTOM @"1"
#define REPEAT_TYPE_GRID @"2"
#define REPEAT_TYPE_VIEWPAGER @"3"
#define REPEAT_TYPE_HLIST @"4"
#define REPEAT_TYPE_VLIST @"5"


@interface ReplaceRuleRepeat : ReplaceRule

-(id)initWith:(UIView*)replaceView
             :(NSDictionary*)replaceJsonLayer
             :(NSString*)replaceJsonKey;


@property(nonatomic, retain) UIView *createdContainer;
@property(nonatomic, retain) NSObject* adapterForRetain;
@property(nonatomic, retain) NSMutableArray *createdRepeatView;

@end

#define CREATED_VIEW_TYPE_NORMAL 1
#define CREATED_VIEW_TYPE_SELECTED 2

@interface CreatedViewInfo : NSObject

-(id)initWithView:(UIView*)v type:(int)type;

@property(nonatomic, retain) UIView *view;
@property int type;

@end