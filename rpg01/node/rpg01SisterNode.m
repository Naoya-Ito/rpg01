
#import "rpg01SisterNode.h"


@implementation rpg01SisterNode

+ (id)sister{
    rpg01SisterNode *node = [rpg01SisterNode spriteNodeWithImageNamed:@"sister0"];
    node.name = SISTER_NAME;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.categoryBitMask = sisterCategory;
    return node;
}


@end
