#import "SKMessageNode.h"

static const CGFloat MARGIN = 10.0f;
static const CGFloat PADDING = 10.0f;
static const CGFloat LINE_HEIGHT = 18.0f;

NSString * const kMessageName = @"message";

@implementation SKMessageNode {
    CGSize _size;
    NSMutableArray *_labels;
    NSInteger _lines;
    NSInteger _chars;
    NSInteger _page;
    NSInteger _pages;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super init]) {
        _size = size;
        [self createNodeContents];
    }
    return self;
}

- (id)initWithNoBox:(CGSize)size {
    if (self = [super init]) {
        _size = size;
        [self createNoBoxContents];
    }
    return self;
}

- (void)createNodeContents {
    self.name = kMessageName;
    
    SKShapeNode *boxNode = [[SKShapeNode alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(MARGIN, MARGIN, _size.width - MARGIN * 2.0f, _size.height - MARGIN * 2.0f);
    CGPathAddRoundedRect(path, NULL, rect, 1.0f, 1.0f);
    //CGPathAddRect(path, NULL, rect);
    boxNode.path = path;
    
    boxNode.lineWidth = 1.0f;
    boxNode.fillColor = [SKColor blueColor];
    boxNode.strokeColor = [SKColor whiteColor];
    boxNode.glowWidth = 0;
    boxNode.alpha = 0.7f;
    
    [self addChild:boxNode];
    
    CGPathRelease(path);
    
    _lines = round((rect.size.height - PADDING * 2.0f) / LINE_HEIGHT);
    _chars = floor((rect.size.width - PADDING * 2.0f) / FONT_SIZE);
    _labels = @[].mutableCopy;
    for (int i = 0; i < _lines; i++) {
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Hiragino Kaku Gothic ProN W3"];
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        labelNode.fontSize = FONT_SIZE;
        CGPoint position = CGPointMake(rect.origin.x + PADDING, rect.origin.y + PADDING + LINE_HEIGHT * i);
        if (i == 0) {
            position.x += FONT_SIZE * (_chars - 1);
        }
        labelNode.position = position;
        [self addChild:labelNode];
        [_labels insertObject:labelNode atIndex:0];
        
        if (i == 0) {
            
        }
    }
    self.message = @" "; // For performance
}

- (void)createNoBoxContents {
    self.name = kMessageName;
    
    SKShapeNode *boxNode = [[SKShapeNode alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(MARGIN, MARGIN, _size.width - MARGIN * 2.0f, _size.height - MARGIN * 2.0f);
    CGPathAddRoundedRect(path, NULL, rect, 1.0f, 1.0f);
    //CGPathAddRect(path, NULL, rect);
    boxNode.path = path;
    
    boxNode.lineWidth = 0.0f;
    boxNode.fillColor = [SKColor blackColor];
    boxNode.strokeColor = [SKColor whiteColor];
    boxNode.glowWidth = 0;
    boxNode.alpha = 0.0f;
    
    [self addChild:boxNode];
    
    CGPathRelease(path);
    
    _lines = round((rect.size.height - PADDING * 2.0f) / LINE_HEIGHT);
    _chars = floor((rect.size.width - PADDING * 2.0f) / FONT_SIZE);
    _labels = @[].mutableCopy;
    for (int i = 0; i < _lines; i++) {
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Hiragino Kaku Gothic ProN W3"];
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        labelNode.fontSize = FONT_SIZE;
        CGPoint position = CGPointMake(rect.origin.x + PADDING, rect.origin.y + PADDING + LINE_HEIGHT * i);
        if (i == 0) {
            position.x += FONT_SIZE * (_chars - 1);
        }
        labelNode.position = position;
        [self addChild:labelNode];
        [_labels insertObject:labelNode atIndex:0];
        
        if (i == 0) {
            
        }
    }
    self.message = @" "; // For performance
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _page = -1;
    _pages = message.length / _chars / (_lines - 1);
    [self next];
}

- (void)next {
    if (![self hasNext]) {
        return;
    }
    _page++;
    for (SKLabelNode *labelNode in _labels) {
        labelNode.text = @"";
    }
    for (int i = 0; i < _lines - 1; i++) {
        NSInteger loc = i *_chars + (_page * (_lines - 1)) * _chars;
        NSInteger len = loc + _chars < _message.length ? _chars : _message.length - loc;
        NSRange range = NSMakeRange(loc, len);
        NSString *m =  [_message substringWithRange:range];
        [(SKLabelNode *)_labels[i] setText:m];
        if (range.location + range.length >= _message.length) {
            break;
        }
    }
    
    if ([self hasNext]) {
        [(SKLabelNode *)_labels.lastObject setText:@"▼"];
    }
}

- (BOOL)hasNext {
    return _page < _pages ;
}

- (NSInteger)getPages{
    return _pages;
}

@end