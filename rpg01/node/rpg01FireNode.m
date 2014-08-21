#import "rpg01FireNode.h"

static const CGFloat FIRE_DISTANCE = 130.0f;
static const CGFloat FIRE_DURATION = 1.0f;

@implementation rpg01FireNode

+ (id)fire:(CGPoint)from {
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.xScale = fire.yScale = 0.3f;
    fire.userData =  @{ @"type" : @"magic"
                        }.mutableCopy;
    fire.position = from;

    fire.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    fire.physicsBody.affectedByGravity = NO;
    fire.physicsBody.categoryBitMask = swordCategory;
    fire.physicsBody.contactTestBitMask = enemyCategory;
    fire.physicsBody.collisionBitMask = 0;
    fire.physicsBody.usesPreciseCollisionDetection = YES;
    
    return  fire;
}

- (SKAction *)fireShot:(CGPoint)from direction:(NSString *)direction{
    // アクション設定
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
