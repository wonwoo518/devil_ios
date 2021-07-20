//
//  WildCardUICollectionView.m
//  devilcore
//
//  Created by Mu Young Ko on 2021/07/17.
//

#import "WildCardUICollectionView.h"

@interface WildCardUICollectionView()

@property BOOL reservedAni;

@end

@implementation WildCardUICollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)asyncScrollTo:(int)index :(BOOL)ani{
    self.reservedAni = ani;
    [self performSelector:@selector(scrollToCore:) withObject:[NSNumber numberWithInt:index] afterDelay:0.1f];
}

-(void)scrollToCore:(NSNumber*)index{
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:self.reservedAni];
}

@end
