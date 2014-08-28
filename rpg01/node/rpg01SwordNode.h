#import <SpriteKit/SpriteKit.h>

@interface rpg01SwordNode : SKSpriteNode
+ (id)sword;
- (NSMutableArray *)readTextures:(int)num;
- (void)swordMove;
- (void)swordMoveMidare;
@end
