#import "rpg01SwordNode.h"

//const int SWORD_IMAGE_NUM = 4;

@implementation rpg01SwordNode

+ (id)sword {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sword"];
    rpg01SwordNode *node = [rpg01SwordNode spriteNodeWithTexture:[atlas textureNamed:@"sword0"]];
    node.userData =  @{ @"type" : @"sword"
                        }.mutableCopy;
    return node;
}

- (NSMutableArray *)readTextures{
    NSMutableArray *textures = @[].mutableCopy;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sword"];
    for( int i=-1; i < 3; i++){
        SKTexture *texture = [atlas textureNamed:[NSString stringWithFormat:@"sword%d",i]];
        [textures addObject:texture];
    }
    return textures;
}

- (void)swordMove{
    SKAction *animate = [SKAction animateWithTextures:[self readTextures] timePerFrame:0.1f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[animate, remove]];
    [self runAction:sequence];
}

@end
