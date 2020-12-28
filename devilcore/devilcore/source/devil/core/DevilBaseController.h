//
//  DevilBaseController.h
//  devilcore
//
//  Created by Mu Young Ko on 2020/12/04.
//

#import <UIKit/UIKit.h>
#import "WildCardScreenTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevilBaseController : UIViewController
{
    int screenWidth, screenHeight;
    CGPoint editingPoint;
    UIView* editingView;
}

- (void)showIndicator;
- (void)hideIndicator;

@end

NS_ASSUME_NONNULL_END
