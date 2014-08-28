#import <SpriteKit/SpriteKit.h>
#import "rpg01Utilities.h"

@interface rpg01FireNode : SKEmitterNode
+ (id)fire:(CGPoint)from;
+ (id)blueFire:(CGPoint)from;
- (void)setPhysic;
- (SKAction *)fireShot:(CGPoint)from direction:(NSString *)direction;
@end