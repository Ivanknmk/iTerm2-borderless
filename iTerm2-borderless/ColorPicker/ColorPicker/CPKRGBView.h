#import <Cocoa/Cocoa.h>

/**
 * A collection of views to facilitate selecting an RGB color. Shows a saturation/brightness
 * map, a hue slider, a hex RGB text field, and separate red, green, and blue text fields.
 */
@interface CPKRGBView : NSView

/** Assign to this to programatically change the color. Will invoke the callback block. */
@property(nonatomic) NSColor *selectedColor;

/**
 * Initializes a new RGB view.
 *
 * @param frameRect The initial frame
 * @param block Invoked whenever self.selectedColor changes
 * @param color The initial selected color
 */
- (instancetype)initWithFrame:(NSRect)frameRect
                        block:(void (^)(NSColor *))block
                        color:(NSColor *)color
                 alphaAllowed:(BOOL)alphaAllowed;

/** Adjusts the frame's size to fit its contents exactly. */
- (void)sizeToFit;

@end
