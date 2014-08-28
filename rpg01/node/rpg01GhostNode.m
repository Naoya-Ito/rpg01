#import "rpg01GhostNode.h"

@implementation rpg01GhostNode
+ (id)ghost{
    rpg01GhostNode *node = [rpg01GhostNode spriteNodeWithImageNamed:@"ghost"];
    node.name = @"ghost";
    node.userData =  @{ @"name" : @"ユーレイ",
                        @"life" : @(12),
                        @"exp" : @(22),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-50.0f),
                        @"attacked" : @(0),
                        @"str" : @(5),
                        @"kieru" : @"OK"
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 45)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory | metalBodyCategory;
    node.physicsBody.contactTestBitMask = swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    
    // 敵のスピード
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( 0, dy);
    
    return node;
}
@end
