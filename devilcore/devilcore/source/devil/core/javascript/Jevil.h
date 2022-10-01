//
//  Jevil.h
//  devilcore
//
//  Created by Mu Young Ko on 2020/12/15.
//

@import JavaScriptCore;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Jevil <JSExport>

+ (instancetype)contactWithName:(NSString *)name
                          phone:(NSString *)phone
                        address:(NSString *)address;

+ (BOOL)isLogin;
+ (void)go:(NSString*)screenName :(id)param;
+ (void)replaceScreen:(NSString*)screenName :(id)param;
+ (void)rootScreen:(NSString*)screenName :(id)param;
+ (void)tab:(NSString*)screenName;
+ (void)finish:(id)callbackData;
+ (void)finishThen:(JSValue *)callback;
+ (void)back;
+ (void)toast:(NSString*)msg;
+ (void)alert:(NSString*)msg;
+ (void)alertFinish:(NSString*)msg;
+ (void)alertThen:(NSString*)msg :(JSValue *)callback;
+ (void)confirm:(NSString*)msg :(NSString*)yes :(NSString*)no :(JSValue *)callback;
+ (void)startLoading;
+ (void)stopLoading;
+ (void)save:(NSString *)key :(NSString *)value;
+ (void)remove:(NSString *)key;
+ (NSString*)get:(NSString *)key;
+ (void)http:(NSString *)method :(NSString *)url :(NSDictionary*)headerObject :(NSDictionary*)body :(JSValue *)callback;
+ (void)get:(NSString *)url then:(JSValue *)callback;
+ (void)getMany:(NSArray *)url then:(JSValue *)callback;
+ (void)post:(NSString *)url :(id)param then:(JSValue *)callback;
+ (void)put:(NSString *)url :(id)param then:(JSValue *)callback;
+ (void)uploadS3:(NSArray*)file :(JSValue *)callback;
+ (void)uploadS3Secure:(NSArray*)paths :(JSValue *)callback;
+ (void)uploadS3Core:(NSArray*)paths :(NSString*)put_url :(JSValue *)callback;
+ (void)sendPushKeyWithDevilServer;
+ (void)getThenWithHeader:(NSString *)url :(id)header :(JSValue *)callback;
+ (void)postThenWithHeader:(NSString *)url :(id)header :(id)param :(JSValue *)callback;
+ (void)update;
+ (void)updateThis;
+ (void)focus:(NSString*)nodeName;
+ (void)hideKeyboard;
+ (void)scrollTo:(NSString*)nodeName :(int)index :(BOOL)noani;
+ (void)scrollUp:(NSString*)nodeName;
+ (void)popup:(NSString*)blockName :(NSDictionary*)param :(JSValue *)callback;
+ (void)popupClose;
+ (void)popupClose:(BOOL)yes;
+ (void)popupAddress:(NSDictionary*)param :(JSValue *)callback;
+ (void)popupSelect:(NSArray *)arrayString :(NSDictionary*)param :(JSValue *)callback;
+ (void)popupDate:(NSDictionary*)param :(JSValue *)callback;
+ (void)popupTime:(NSDictionary*)param :(JSValue *)callback;
+ (void)resetTimer:(NSString *)nodeName;
+ (int)getViewPagerSelectedIndex:(NSString *)nodeName;
+ (void)isWifi:(JSValue *)callback;
+ (void)wifiList:(JSValue *)callback;
+ (void)wifiConnect:(NSString*)ssid :(NSString*)password :(JSValue *)callback;
+ (void)gallery:(NSDictionary*)param :(JSValue *)callback;
+ (void)galleryList:(NSDictionary*)param :(JSValue *)callback;
+ (void)gallerySystem:(NSDictionary*)param :(JSValue *)callback;
+ (void)cameraSystem:(NSDictionary*)param :(JSValue *)callback;
+ (void)camera:(NSDictionary*)param :(JSValue *)callback;
+ (void)cameraQr:(NSDictionary*)param :(JSValue *)callback;
+ (void)cameraQrClose;
+ (void)share:(NSString*)url;
+ (void)out:(NSString*)url;
+ (void)saveFileFromUrl:(NSDictionary*)param :(JSValue *)callback;
+ (void)downloadAndView:(NSString*)url;
+ (void)downloadAndShare:(NSString*)url;
+ (void)download:(NSString*)url;
+ (void)sound:(NSDictionary*)param;
+ (id)soundCurrentInfo;
+ (void)soundCallback:(JSValue*)callback;
+ (void)soundControlCallback:(JSValue *)callback;
+ (void)soundTick:(JSValue*)callback;
+ (void)soundPause;
+ (void)soundStop;
+ (void)soundResume;
+ (BOOL)soundIsPlaying;
+ (void)soundMove:(int)sec;
+ (void)soundSeek:(int)sec;
+ (void)soundSpeed:(NSString*)speed;
+ (void)speechRecognizer:(NSDictionary*)param :(JSValue*)callback;
+ (void)stopSpeechRecognizer;
+ (NSString*)recordStatus;
+ (void)recordStart:(NSDictionary*)param :(JSValue*)callback;
+ (void)recordTick:(JSValue*)callback;
+ (void)recordStop:(JSValue*)callback;
+ (void)recordCancelCallback:(JSValue*)callback;

+ (void)getLocation:(NSDictionary*)param :(JSValue*)callback;
+ (void)setText:(NSString*)node :(NSString*)text;
+ (void)webLoad:(NSString*)node :(JSValue *)callback;
+ (void)scrollDragged:(NSString*)node :(JSValue *)callback;
+ (void)scrollEnd:(NSString*)node :(JSValue *)callback;
+ (void)textChanged:(NSString*)node :(JSValue *)callback;
+ (void)textFocusChanged:(NSString*)node :(JSValue *)callback;
+ (void)videoViewAutoPlay;
+ (void)getCurrentLocation:(NSDictionary*)param :(JSValue*)callback;
+ (void)getCurrentPlace:(NSDictionary*)param :(JSValue*)callback;
+ (void)searchPlace:(NSDictionary*)param :(JSValue*)callback;
+ (JSValue*)parseUrl:(NSString*)url;
+ (void)menuReady:(NSString*)node :(NSDictionary*)param;
+ (void)menuOpen:(NSString*)node;
+ (void)menuClose;
+ (void)setTimer:(NSString*)key :(int)milli_sec :(JSValue*)callback;
+ (void)removeTimer:(NSString*)key;
+ (void)beaconScan:(NSDictionary*)param :(JSValue*)callback :(JSValue*)foundCallback;
+ (void)beaconStop;
+ (void)createDeepLink:(NSDictionary*)param :(JSValue*)callback;
+ (NSString*)getReserveUrl;
+ (NSString*)popReserveUrl;
+ (BOOL)consumeStandardReserveUrl;
+ (BOOL)standardUrlProcess:(NSString*)url;
+ (void)localPush:(id)param;
+ (void)toJpg:(NSString*)node :(JSValue*)callback;
+ (void)androidEscapeDozeModeIf:(NSString*)msg:(NSString*)yes:(NSString*)no;
+ (void)video:(NSDictionary*)param;
+ (void)photo:(NSDictionary*)param;
+ (void)timer:(NSString*)node :(int)sec;
+ (void)custom:(NSString*)function;
+ (void)bleList:(NSDictionary*)param :(JSValue *)callback;
+ (void)bleConnect:(NSString*)udid;
+ (void)bleDisconnect:(NSString*)udid;
+ (void)bleRelease:(NSString*)udid;
+ (void)bleCallback:(NSString*)command :(JSValue *)callback;
+ (void)bleWrite:(NSDictionary*)param :(JSValue*)callback;
+ (void)bleRead:(NSDictionary*)param :(JSValue*)callback;
+ (void)fileChooser:(NSDictionary*)param :(JSValue*)callback;
+ (void)imageMapCallback:(NSString*)nodeName :(NSString*)command :(JSValue*)callback;
+ (void)imageMapLocation:(NSString*)nodeName :(NSString*)key :(JSValue*)callback;
+ (void)imageMapMode:(NSString*)nodeName :(NSString*)mode :(NSDictionary*)param;
+ (NSString*)getByte:(NSString*)text;
+ (void)configHost:(NSString*)host;

@end

@interface Jevil : NSObject <Jevil>

@end

NS_ASSUME_NONNULL_END
