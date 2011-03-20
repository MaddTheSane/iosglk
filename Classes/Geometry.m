/* Geometry.m: A size descriptor for a Glk window view
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/


#import "Geometry.h"
#import "GlkLibrary.h"
#import "StyleSet.h"

@implementation Geometry

@synthesize division;
@synthesize keytag;
@synthesize keystyleset;
@synthesize size;
@synthesize hasborder;
@synthesize vertical;
@synthesize backward;
@synthesize child1tag;
@synthesize child2tag;

- (id) init {
	self = [super init];
	
	if (self) {
		keytag = nil;
		keystyleset = nil;
		child1tag = nil;
		child2tag = nil;
	}
	
	return self;
}

- (void) dealloc {
	self.keytag = nil;
	self.keystyleset = nil;
	self.child1tag = nil;
	self.child2tag = nil;
	[super dealloc];
}

/* Standard copy method. Returns a retained object which is a (shallow) copy. */
- (id) copyWithZone:(NSZone *)zone {
	Geometry *copy = [[Geometry allocWithZone: zone] init];
	copy.dir = dir; /* sets vertical, backward */
	copy.division = division;
	copy.hasborder = hasborder;
	copy.keytag = keytag;
	copy.keystyleset = keystyleset;
	copy.size = size;
	copy.child1tag = child1tag;
	copy.child2tag = child2tag;
	return copy;
}

- (glui32) dir {
	return dir;
}

- (void) setDir:(glui32)val {
	dir = val;
	
	vertical = (dir == winmethod_Left || dir == winmethod_Right);
	backward = (dir == winmethod_Left || dir == winmethod_Above);
}

- (void) computeDivision:(CGRect)bbox for1:(CGRect *)boxref1 for2:(CGRect *)boxref2 {
	CGFloat min, max, diff;
	CGFloat split;
	CGFloat splitwid;	
		
	if (vertical) {
		min = bbox.origin.x;
		max = min + bbox.size.width;
		splitwid = 4; //content_metrics.inspacingx;
	}
	else {
		min = bbox.origin.y;
		max = min + bbox.size.height;
		splitwid = 4; //content_metrics.inspacingy;
	}
	if (!hasborder)
		splitwid = 0;
	diff = max - min;

	if (division == winmethod_Proportional) {
		split = floorf((diff * size) / 100.0);
	}
	else if (division == winmethod_Fixed) {
		split = 0;
		if (keystyleset) {
			/* This really should depend on the type of the keywin also. Graphics windows are in pixels, etc. But we'll add that later. */
			if (!vertical)
				split = (size * keystyleset.charbox.height + keystyleset.marginframe.size.height);
			else
				split = (size * keystyleset.charbox.width + keystyleset.marginframe.size.width);
		}
		split = ceilf(split);
	}
	else {
		/* default behavior for unknown division method */
		split = floorf(diff / 2);
	}

	/* Split is now a number between 0 and diff. Convert that to a number
	   between min and max; also apply upside-down-ness. */
	if (!backward) {
		split = max-split-splitwid;
	}
	else {
		split = min+split;
	}

	/* Make sure it's really between min and max. */
	if (min >= max) {
		split = min;
	}
	else {
		split = fminf(fmaxf(split, min), max-splitwid);
	}
	
	CGRect box1 = bbox;
	CGRect box2 = bbox;

	if (vertical) {
		box1.size.width = split - bbox.origin.x;
		box2.origin.x = split + splitwid;
		box2.size.width = (bbox.origin.x+bbox.size.width) - box2.origin.x;
	}
	else {
		box1.size.height = split - bbox.origin.y;
		box2.origin.y = split + splitwid;
		box2.size.height = (bbox.origin.y+bbox.size.height) - box2.origin.y;
	}
	
	*boxref1 = box1;
	*boxref2 = box2;
}

@end
