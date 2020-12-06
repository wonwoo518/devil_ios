//
//  WildCardMeta.h
//  CloudJsonViewer
//
//  Created by Mu Young Ko on 2018. 6. 18..
//  Copyright © 2018년 Mu Young Ko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WildCardUIView;
@class WildCardTrigger;
@class WildCardMeta;

@protocol WildCardConstructorInstanceDelegate<NSObject>
@required
-(BOOL)onInstanceCustomAction:(WildCardMeta *)meta function:(NSString*)functionName args:(NSArray*)args view:(WildCardUIView*) node;
@end



@interface WildCardMeta : NSObject

@property (nonatomic, retain) WildCardUIView* rootView;
@property (nonatomic, retain) NSMutableArray* replaceRules;
@property (nonatomic, retain) NSMutableDictionary* generatedViews;
@property (nonatomic, retain) NSDictionary* cloudJson;
@property (nonatomic, retain) NSMutableDictionary* correspondData;
@property (nonatomic, retain) NSMutableDictionary* triggersByName;

@property (nonatomic, retain) NSMutableDictionary* nextChain;
@property (nonatomic, retain) NSMutableDictionary* nextChainHeaderNodes;
@property (nonatomic, retain) NSMutableDictionary* nextChainChildNodes;
@property (nonatomic, retain) NSArray* layoutPath;

@property (nonatomic, retain) NSMutableDictionary* gravityNodes;

@property (nonatomic, retain) NSMutableDictionary* wrapContentNodes;

@property (nonatomic, retain) WildCardMeta* parentMeta;

@property (nonatomic, weak, nullable) id <WildCardConstructorInstanceDelegate> wildCardConstructorInstanceDelegate;

-(void)addNextChain:(UIView*)prevView next:(UIView*)nextView margin:(int)margin horizontal:(BOOL)horizontal depth:(int)depth;

-(void)addGravity:(UIView*)view depth:(int)depth;
-(void)addWrapContent:(UIView*)view depth:(int)depth;

-(void) requestLayout;

-(void)addTriggerAction:(WildCardTrigger*)trigger;

-(void) doAllActionOfTrigger:(NSString*)triggerType node:(NSString*)nodeName;

-(UILabel*)getTextView:(NSString*)name;
-(UIImageView*)getImageView:(NSString*)name;
-(UIView*)getView:(NSString*)name;
-(UITextField*)getInput:(NSString*)name;
-(void)update;

-(void)viewPagerMove:(NSString*)vp to:(int)distance;

@end


