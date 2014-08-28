#import "rpg01SwordNode.h"

//const int SWORD_IMAGE_NUM = 4;

@implementation rpg01SwordNode

+ (id)sword {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sword"];
    rpg01SwordNode *node = [rpg01SwordNode spriteNodeWithTexture:[atlas textureNamed:@"sword0"]];
    node.name = @"sword";
    node.userData =  @{ @"type" : @"sword"
                        }.mutableCopy;
    return node;
}

- (NSMutableArray *)readTextures:(int)num{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sword"];
    for( int i=0; i < num; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"sword%d",i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)swordMove{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:4] timePerFrame:0.1f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[animate, remove]];
    [self runAction:sequence];
}

- (void)swordMoveMidare{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures:6] timePerFrame:0.1f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[animate, remove]];
    [self runAction:sequence];
}

@end
