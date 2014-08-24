#import "rpg01DoorNode.h"

@implementation rpg01DoorNode

+ (id)door{
    rpg01DoorNode *door = [rpg01DoorNode spriteNodeWithImageNamed:@"door"];
    door.name = DOOR_NAME;
    door.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    door.physicsBody.affectedByGravity = NO;
    door.physicsBody.categoryBitMask = doorCategory;
    door.physicsBody.collisionBitMask = 0;
    return door;
}

@end
