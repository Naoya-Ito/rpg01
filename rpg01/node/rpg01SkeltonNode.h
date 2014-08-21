#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01SkeltonNode : SKSpriteNode

+ (id)skelton;
- (NSMutableArray *)readTextures;
- (void)skeltonMove;
@end
