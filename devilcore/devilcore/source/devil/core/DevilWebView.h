//
//  DevilWebView.h
//  devilcore
//
//  Created by Mu Young Ko on 2020/12/04.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevilWebView : WKWebView< WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property BOOL (^shouldOverride)(NSString* url);

@end

NS_ASSUME_NONNULL_END
