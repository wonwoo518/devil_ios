//
//  WildCardUILabel.h
//  CloudJsonViewer
//
//  Created by Mu Young Ko on 2018. 6. 18..
//  Copyright © 2018년 Mu Young Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WildCardUILabel : UILabel

@property BOOL stroke;
@property int alignment;
@property BOOL wrap_width;
@property float max_width;
@property float max_height;
@property BOOL wrap_height;
@property BOOL textSelection;

@property CGRect strokeRect;

@end
