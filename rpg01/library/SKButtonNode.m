#import "SKButtonNode.h"

@implementation SKButtonNode
- (id)initWithFontNamed:(NSString *)fontName {
    if (self = [super initWithFontNamed:fontName]) {
        self.color = [SKColor grayColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (!self.hidden) {
        _highlighted = highlighted;
    }
    self.colorBlendFactor = _highlighted ? 0.7f : 0;
}
@end
