#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01BatNode : SKSpriteNode
+ (id)bat;
- (NSMutableArray *)readTextures;
- (void)fly;
@end
