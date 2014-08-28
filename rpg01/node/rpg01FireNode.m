#import "rpg01FireNode.h"

static const CGFloat FIRE_DISTANCE = 130.0f;
static const CGFloat FIRE_DURATION = 1.0f;

@implementation rpg01FireNode

+ (id)fire:(CGPoint)from {
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
    rpg01FireNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.name = FIRE_NAME;
    fire.userData =  @{ @"type" : @"magic"
                        }.mutableCopy;
    fire.position = from;
    return fire;
}

+ (id)blueFire:(CGPoint)from {
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"blue_fire" ofType:@"sks"];
    rpg01FireNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.name = FIRE_NAME;
    fire.userData =  @{ @"type" : @"magic"
                        }.mutableCopy;
    fire.position = from;
    return fire;
}

- (void)setPhysic{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = swordCategory;
    self.physicsBody.contactTestBitMask = enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}

- (SKAction *)fireShot:(CGPoint)from direction:(NSString *)direction{
    CGPoint target;
    if([direction isEqualToString:@"up"]){
        target = CGPointMake(from.x, from.y + FIRE_DISTANCE);
    } else if ([direction isEqualToString:@"down"]){
        target = CGPointMake(from.x, from.y - FIRE_DISTANCE);
    } else if ([direction isEqualToString:@"right"]){
        target = CGPointMake(from.x + FIRE_DISTANCE, from.y);
    } else if ([direction isEqualToString:@"left"]){
        target = CGPointMake(from.x - FIRE_DISTANCE, from.y);
    }
    SKAction *move = [SKAction moveTo:target duration:FIRE_DURATION];
    return move;
}

@end
