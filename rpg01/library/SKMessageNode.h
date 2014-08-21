#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

extern NSString * const kMessageName;
@interface SKMessageNode : SKNode

@property (nonatomic) NSString *message;
- (id)initWithSize:(CGSize)size;
- (id)initWithNoBox:(CGSize)size;
- (void)next;
- (BOOL)hasNext;
- (NSInteger)getPages;
@end