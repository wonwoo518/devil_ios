//
//  DevilUtil.h
//  devilcore
//
//  Created by Mu Young Ko on 2021/04/11.
//

#import <Foundation/Foundation.h>
#import "DevilController.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(argbValue) \
[UIColor colorWithRed:((float)((argbValue & 0x00FF0000) >> 16))/255.0 \
green:((float)((argbValue & 0x0000FF00) >>  8))/255.0 \
blue:((float)((argbValue & 0x000000FF) >>  0))/255.0 \
alpha:((float)((argbValue & 0xFF000000) >>  24))/255.0]

#define trim( str ) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
#define empty( str ) ( str == nil || [str length] == 0)

#define urlencode( str ) [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]
#define urldecode( str ) [str stringByRemovingPercentEncoding]  

@interface DevilUtil : NSObject

+(DevilUtil*)sharedInstance;
+ (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees;
+ (void) convertMovToMp4:(NSString*)path to:(NSString*)outputPath callback:(void (^)(id res))callback;
+ (NSString*) changeFileExt:(NSString*)path to:(NSString*)ext;
+ (NSString*) getFileExt:(NSString*)path;
+ (NSString*) getFileName:(NSString*)path;
+ (NSInteger)sizeOfFile:(NSString *)filePath;
+ (UIImage *) getThumbnail:(NSString*)path;
+ (int) getDuration:(NSString*)path;
+(void)httpPutQueueClear;
+(void)httpPut:(NSString*)url contentType:(id _Nullable)contentType data:(NSData*)data complete:(void (^)(id res))callback;
+(id) parseUrl:(NSString*)url;
+(id) queryToJson:(NSURL*)url;
+ (void)clearTmpDirectory;
+ (UIImage *)resizeImageProperly:(UIImage *)image;
+ (BOOL)isWifiConnection;
+ (BOOL)isPhoneX;
+(void)saveFileFromUrl:(NSString*)url to:(NSString*)filename progress:(void (^)(int rate))progress_callback complete:(void (^)(id res))complete_callback;
+(void)download:(NSString*)url to:(NSString*)file_path progress:(void (^)(int rate))progress_callback complete:(void (^)(id res))complete_callback;

+(void)cancelDownloadingFile:(NSString*)url;
+(NSString*)replaceUdidPrefixDir:(NSString*)url;
+(void)showAlert:(DevilController*)vc msg:(NSString*)msg showYes:(BOOL)showYes yesText:(NSString*)yesText cancelable:(BOOL)cancelable callback:(void (^)(BOOL res))callback;
+(NSString*)orientationToString:(UIInterfaceOrientationMask)mask;
+(NSString *) byteToHex : (NSData*)data;

+(NSString*)sha256:(NSString*)text;
+(NSString*)sha256ToHex:(NSString*)text;
+(NSString*)sha256ToHash:(NSString*)text;
+(NSString*)sha512ToHash:(NSString*)text;
+(NSString*)fileNameToContentType:(NSString*)path;
+(void)multiPartUpload:(NSString*)url header:(id)header name:(NSString*)name filename:(NSString*)filename filePath:(NSString*)filePath complete:(void (^)(id res))callback;

@end

NS_ASSUME_NONNULL_END
