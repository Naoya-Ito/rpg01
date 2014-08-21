#import "rpg01BatNode.h"

const int BAT_IMAGE_NUM = 2;

@implementation rpg01BatNode{
    int _boxes;
}

+ (id)bat {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"bat"];
    rpg01BatNode *node = [rpg01BatNode spriteNodeWithTexture:[atlas textureNamed:@"bat0"]];
    node.userData =  @{ @"name" : @"コウモリ",
                        @"life" : @(18),
                        @"exp" : @(5),
                        @"speed_dx" : @(40 + arc4random()%81),
                        @"speed_dy" : @(-200.0f),
                        @"attacked" : @(3),
                        @"str" : @(2)                        
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0;
    node.physicsBody.friction = 0;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    
    // 敵のスピード
    int dx = [node.userData[@"speed_dx"] intValue];
    int dy = [node.userData[@"speed_dy"] intValue];
    node.physicsBody.velocity = CGVectorMake( dx, dy);    
    
    return node;
}

- (NSMutableArray *)readTextures{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"bat"];
    for( int i=0; i < BAT_IMAGE_NUM; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"bat%d",i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)fly{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures] timePerFrame:0.5f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [self runAction:forever];
}

@end
