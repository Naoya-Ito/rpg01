
#import "rpg01DragonNode.h"

@implementation rpg01DragonNode
+ (id)dragon{
    rpg01DragonNode *node = [rpg01DragonNode spriteNodeWithImageNamed:@"dragon"];
    node.name = @"dragon";
    //rpg01DragonNode *node = [rpg01DragonNode spriteNodeWithImageNamed:@"mon_013.bmp"];
    
    node.userData =  @{ @"name" : @"ドラゴン",
                        @"life" : @(80),
                        @"exp" : @(50),
                        @"speed_dx" : @(0),
                        @"speed_dy" : @(-45.0f),
                        @"attacked" : @(0),
                        @"str" : @(20),
                        @"kieru" : @"OK"                        
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE*2, TILE_SIZE*2)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    
    // 敵のスピード
    int dx = [node.userData[@"speed_dx"] intValue];
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( dx, dy);
    
    return node;
}
@end
