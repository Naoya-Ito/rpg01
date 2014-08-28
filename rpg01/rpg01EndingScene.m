#import "rpg01EndingScene.h"
#import "SKMessageNode.h"

@implementation rpg01EndingScene{
    int _story;
}
- (void)createSceneContents
{
    _story = 0;
    [self playBGM:@"clear" type:@"mp3"];
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
    
    NSArray *textures = [self _textures:@"hiroin" withRow:3 cols:1];
    SKSpriteNode *heroin = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    heroin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:heroin];
}



- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_story == 0){
        _story = 1;
    } else if (_story == 1){
        _story = 2;
    } else if (_story == 2){
        _story = 3;
    } else if (_story == 3){
        _story = 4;
    } else if (_story == 4){
        _story = 5;
    } else if (_story == 5){
        _story = 6;
    } else if (_story == 6){
        _story = 7;
    } else if (_story == 7){
        [self stopBGM];
        [self loadScene:@"opening"];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(_story == 0){
        [self messageNode].message = @"さすがです大佐！　我が軍の大勝利です！！";
    } else if (_story == 1){
        [self messageNode].message = @"長く……辛い戦いでしたね";
    } else if (_story == 2){
        [self messageNode].message = @"私はずっと忘れません。多くのモンスターにたった一人で立ち向かった大佐の姿を……";
    } else if (_story == 3){
        [self messageNode].message = @"大佐……いえ、これからは勇者と呼ばせてください！！";
    } else if (_story == 4){
        [self messageNode].message = @"というわけで新たな勇者の誕生を祝って";
    } else if (_story == 5){
        [self messageNode].message = @"今夜は焼き肉パーティーです！";
    } else if (_story == 6){
        [self messageNode].message = @"…… Thank you for playing";
    } else if (_story == 7){
        [self messageNode].message = @"そして焼き肉へ";
    }
}

@end
