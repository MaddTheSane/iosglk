/* GlkWinBufferView.h: Glk textbuffer window view
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/

#import <UIKit/UIKit.h>
#import "GlkWindowView.h"

@class StyledTextView;
@class MoreBoxView;

@interface GlkWinBufferView : GlkWindowView <UIScrollViewDelegate> {
	StyledTextView *textview;
	MoreBoxView *moreview;
	
	CGRect lastLayoutBounds;
	BOOL nowcontentscrolling;
}

@property (nonatomic, retain) StyledTextView *textview;
@property (nonatomic, retain) MoreBoxView *moreview;
@property (nonatomic) BOOL nowcontentscrolling;

- (BOOL) pageDownOnInput;

@end
