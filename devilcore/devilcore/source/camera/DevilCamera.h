//
//  DevilCamera.h
//  devilcore
//
//  Created by Mu Young Ko on 2021/04/11.
//

#import <Foundation/Foundation.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface DevilCamera : NSObject
+(void)changePhAssetToUrlPath:(id)list callback:(void (^)(id res))callback;
+(void)getGelleryList:(UIViewController*)vc param:(id)param callback:(void (^)(id res))callback;
+(void)camera:(UIViewController*)vc param:(id)param callback:(void (^)(id res))callback;
+(void)cameraQr:(UIViewController*)vc param:(id)param callback:(void (^)(id res))callback;
-(void)captureResult:(id)result;

@end

NS_ASSUME_NONNULL_END
