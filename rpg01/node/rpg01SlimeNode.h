#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01SlimeNode : SKSpriteNode
+ (id)slime;
- (NSMutableArray *)readTextures;
- (void)slimeAnimation;
- (void)moveSlime;
@end