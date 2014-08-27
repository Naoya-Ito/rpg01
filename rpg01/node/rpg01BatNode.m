#import "rpg01BatNode.h"

const int BAT_IMAGE_NUM = 2;

@implementation rpg01BatNode{
    int _boxes;
}

+ (id)bat {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"bat"];
    rpg01BatNode *node = [rpg01BatNode spriteNodeWithTexture:[atlas textureNamed:@"bat0"]];
    node.name = ENEMY_BAT_NAME;
    int dx;
    if(arc4random()%2 == 1){
        dx = 80;
    } else {
        dx = -80;
    }
    
    node.userData =  @{ @"name" : @"コウモリ",
                        @"life" : @(10),
                        @"exp" : @(5),
                        @"speed_dx" : @(dx),
                        @"speed_dy" : @(-80.0f),
                        @"attacked" : @(3),
                        @"str" : @(2),
                        @"kieru" : @"OK"
                        }.mutableCopy;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = enemyCategory;
    node.physicsBody.contactTestBitMask = heroCategory | swordCategory | houseCategory;
    node.physicsBody.collisionBitMask = worldCategory;
    node.physicsBody.friction = 0;
    
    // 敵のスピード
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
