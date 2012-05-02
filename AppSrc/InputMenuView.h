/* InputMenuView.h: A popmenu subclass that can display the command history or common-verb palette
 for IosGlk, the iOS implementation of the Glk API.
 Designed by Andrew Plotkin <erkyrath@eblong.com>
 http://eblong.com/zarf/glk/
 */

#import <UIKit/UIKit.h>
#import "PopMenuView.h"

typedef enum InputMenuMode_enum {
	inputmenu_None = 0,
	inputmenu_History = 1,
	inputmenu_Palette = 2,
} InputMenuMode;

@class HistoryMenuView;
@class PaletteMenuView;
@class GlkWindowView;

@interface InputMenuView : PopMenuView {
	GlkWindowView *winview;
	HistoryMenuView *historymenu;
	PaletteMenuView *palettemenu;
	
	InputMenuMode mode;
	NSArray *history;
}

@property (nonatomic, retain) GlkWindowView *winview;
@property (nonatomic, retain) IBOutlet UIButton *historybutton;
@property (nonatomic, retain) IBOutlet UIButton *palettebutton;
@property (nonatomic, retain) IBOutlet HistoryMenuView *historymenu;
@property (nonatomic, retain) IBOutlet PaletteMenuView *palettemenu;
@property (nonatomic, retain) UILabel *displaylabel;
@property (nonatomic, retain) NSArray *history;
@property (nonatomic, retain) NSString *displaycommand;

- (id) initWithFrame:(CGRect)frame buttonFrame:(CGRect)rect view:(GlkWindowView *)winview history:(NSArray *)historylist;
- (void) setMode:(InputMenuMode)mode;
- (void) setDisplayCommand:(NSString *)val;
- (void) acceptCommand:(NSString *)cmd replace:(BOOL)replace close:(BOOL)closemenu;
- (IBAction) handlePaletteButton:(id)sender;
- (IBAction) handleHistoryButton:(id)sender;

@end


@interface HistoryMenuView : UIView {
	InputMenuView *menuview;
	UILabel *baselabel;
	NSMutableArray *labels;
	
	CGRect labelbox;
	CGFloat labelheight;
	CGFloat extraheight;
	
	BOOL disabled;
	int selection;
}

@property (nonatomic, retain) IBOutlet InputMenuView *menuview;
@property (nonatomic, retain) IBOutlet UILabel *baselabel;
@property (nonatomic, retain) NSMutableArray *labels;

- (void) setUpFromHistory:(NSArray *)history;
- (void) selectLabel:(int)val;

@end


@interface PaletteMenuView : UIView {
	InputMenuView *menuview;
	NSMutableArray *labels;

	CGRect origbounds;

	UILabel *selection; // not retained; always refers to an entry in labels
}

@property (nonatomic, retain) IBOutlet InputMenuView *menuview;
@property (nonatomic, retain) NSMutableArray *labels;

- (void) setUp;
- (void) selectLabel:(UILabel *)val;

@end
