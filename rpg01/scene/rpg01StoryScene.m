#import "rpg01StoryScene.h"

#import "SKMessageNode.h"

@interface rpg01StoryScene () <SKPhysicsContactDelegate>
@end

@implementation rpg01StoryScene

- (void)createSceneContents
{
    self.physicsWorld.contactDelegate = self;
    
    rpg01MapNode *map = [[rpg01MapNode alloc] initWithMapNamed:@"shop" base_height:0];
    [self addChild:map];
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([_params[@"story"] isEqualToString:@"1-crear"]){
        _params[@"story"] = @"2-00";
    } else if([_params[@"story"] isEqualToString:@"2-00"]){
//        _params[@"story"] = @"2-start";
//        [self loadSceneWithParam:@"play" params:_params];
        
        _params[@"story"] = @"end";
        [self loadSceneWithParam:@"opening" params:_params];
    } else if([_params[@"story"] isEqualToString:@"end"]){
        [self loadSceneWithParam:@"opening" params:_params];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if([_params[@"story"] isEqualToString:@"1-crear"]){
        [self messageNode].message = @"まさか半日で試練をクリアするとはな……やるじゃねえか。";
    } else if([_params[@"story"] isEqualToString:@"2-00"]){
        [self messageNode].message = @"次はダンジョンの5階を目指すんだな";
    } else if([_params[@"story"] isEqualToString:@"2-crear"]){
        [self messageNode].message = @"やるじゃねえか。続きはまだ作成中なのでタイトル画面に戻りな";
        _params[@"story"] = @"end";
    } else if([_params[@"story"] isEqualToString:@"end"]){
        [self messageNode].message = @"続きはまだ作成中なのでタイトル画面に戻りな";
        _params[@"story"] = @"end";
    }

}

@end
