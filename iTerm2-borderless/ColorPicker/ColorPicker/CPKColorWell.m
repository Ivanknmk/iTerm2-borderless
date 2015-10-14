#import "CPKColorWell.h"
#import "CPKPopover.h"
#import "NSObject+CPK.h"

@protocol CPKColorWellViewDelegate
@property(nonatomic, readonly) void (^willOpenPopover)();
@property(nonatomic, readonly) void (^willClosePopover)();
- (NSRect)presentationRect;
- (NSView *)presentingView;
- (BOOL)isContinuous;
@end

/** This really should be an NSCell. It provides the implementation of the CPKColorWell. */
@interface CPKColorWellView : CPKSwatchView

/** Block invoked when the user changes the color. Only called for continuous controls. */
@property(nonatomic, copy) void (^colorDidChange)(NSColor *);

/** User can adjust alpha value. */
@property(nonatomic, assign) BOOL alphaAllowed;

/** Color well is disabled? */
@property(nonatomic, assign) BOOL disabled;

@property(nonatomic, weak) id<CPKColorWellViewDelegate> delegate;

@end

@interface CPKColorWellView() <NSPopoverDelegate>
@property(nonatomic) BOOL open;
@property(nonatomic) CPKPopover *popover;
@property(nonatomic, copy) void (^willClosePopover)(NSColor *);

// The most recently selected color from the picker. Differs from self.color if
// the control is not continuous (self.color is the swatch color).
@property(nonatomic) NSColor *selectedColor;
@end

@interface CPKColorWell() <CPKColorWellViewDelegate>
@end

@implementation CPKColorWellView

- (void)awakeFromNib {
    self.cornerRadius = 3;
    self.open = NO;
}

// Use mouseDown so this will work in a NSTableView.
- (void)mouseDown:(NSEvent *)theEvent {
    if (!_disabled && !self.open && theEvent.clickCount == 1) {
        [self openPopOverRelativeToRect:_delegate.presentationRect
                                 ofView:_delegate.presentingView];
    }
}

- (void)openPopOverRelativeToRect:(NSRect)presentationRect ofView:(NSView *)presentingView {
    __weak __typeof(self) weakSelf = self;
    self.selectedColor = self.color;
    self.popover =
        [CPKPopover presentRelativeToRect:presentationRect
                                   ofView:presentingView
                            preferredEdge:CGRectMinYEdge
                             initialColor:self.color
                             alphaAllowed:self.alphaAllowed
                       selectionDidChange:^(NSColor *color) {
                           self.selectedColor = color;
                           if (weakSelf.delegate.isContinuous) {
                               weakSelf.color = color;
                               if (weakSelf.colorDidChange) {
                                   weakSelf.colorDidChange(color);
                               }
                           }
                           [weakSelf setNeedsDisplay:YES];
                       }];
    self.open = YES;
    self.popover.willClose = ^() {
        if (weakSelf.willClosePopover) {
            weakSelf.willClosePopover(weakSelf.color);
        }
        weakSelf.open = NO;
        weakSelf.popover = nil;
    };
    if (weakSelf.delegate.willOpenPopover) {
        weakSelf.delegate.willOpenPopover();
    }
}

- (void)setOpen:(BOOL)open {
    _open = open;
    [self updateBorderColor];
}

- (void)updateBorderColor {
    if (self.disabled) {
        self.borderColor = [NSColor grayColor];
    } else if (self.open) {
        self.borderColor = [NSColor lightGrayColor];
    } else {
        self.borderColor = [NSColor darkGrayColor];
    }
    [self setNeedsDisplay:YES];
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    [self updateBorderColor];
    if (disabled && self.popover) {
        [self.popover performClose:self];
    }
}

@end

@implementation CPKColorWell {
  CPKColorWellView *_view;
  BOOL _continuous;
}

// This is the path taken when created programatically.
- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    [self load];
  }
  return self;
}

// This is the path taken when loaded from a nib.
- (void)awakeFromNib {
  [self load];
}

- (void)load {
    if (_view) {
        return;
    }

    _continuous = YES;
    _view = [[CPKColorWellView alloc] initWithFrame:self.bounds];
    _view.delegate = self;
    [self addSubview:_view];
    _view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.autoresizesSubviews = YES;
    _view.alphaAllowed = _alphaAllowed;
    __weak __typeof(self) weakSelf = self;
    _view.colorDidChange = ^(NSColor *color) {
        [weakSelf sendAction:weakSelf.action to:weakSelf.target];
    };
    _view.willClosePopover = ^(NSColor *color) {
        if (!weakSelf.continuous) {
            [weakSelf sendAction:weakSelf.action to:weakSelf.target];
        }
        if (weakSelf.willClosePopover) {
            weakSelf.willClosePopover();
        }
    };
}

- (NSColor *)color {
  return _view.selectedColor;
}

- (void)setColor:(NSColor *)color {
    _view.color = color;
    _view.selectedColor = color;
}

- (void)setAlphaAllowed:(BOOL)alphaAllowed {
  _alphaAllowed = alphaAllowed;
  _view.alphaAllowed = alphaAllowed;
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  _view.disabled = !enabled;
}

- (void)setContinuous:(BOOL)continuous {
  _continuous = continuous;
}

- (BOOL)isContinuous {
  return _continuous;
}

- (NSRect)presentationRect {
  return self.bounds;
}

- (NSView *)presentingView {
  return self;
}

@end
