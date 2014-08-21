#import "rpg01BaseScene.h"
#import "rpg01OpeningScene.h"
#import "rpg01TitleScene.h"
#import "rpg01InputScene.h"
#import "rpg01PlayScene.h"
#import "rpg01GameOverScene.h"
#import "rpg01StoryScene.h"
#import "rpg01StatusScene.h"
#import "rpg01FieldScene.h"

@implementation rpg01BaseScene

static const CGFloat SCENE_DURATION = 0.6f;

- (id)initWithSize:(CGSize)size name:(NSString *)name {
    if (self = [super initWithSize:size]) {
    }
    return self;
}

- (id)initWithParam:(CGSize)size name:(NSString *)name params:(NSMutableDictionary *)params{
    _params = params;
    if (self = [super initWithSize:size]) {
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
}

- (void)loadScene:(NSString *)name {
    [self loadSceneWithParam:name params:nil];
}

- (void)loadSceneWithParam:(NSString *)name params:(NSMutableDictionary *)params{
    SKScene *scene;
    if ([name hasPrefix:@"title"]) {
        scene = [[rpg01TitleScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"input"]) {
        scene = [[rpg01InputScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"play"]) {
        scene = [[rpg01PlayScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"gameOver"]) {
        scene = [[rpg01GameOverScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"opening"]) {
        scene = [[rpg01OpeningScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"story"]) {
        scene = [[rpg01StoryScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"status"]) {
        scene = [[rpg01StatusScene alloc] initWithParam:self.size name:name params:params];
    } else if ([name hasPrefix:@"field"]) {
        scene = [[rpg01FieldScene alloc] initWithParam:self.size name:name params:params];
    } else {
        NSLog(@"not exist scene. scene = %@", scene);
    }
    if (scene) {
        SKTransition *transition = [SKTransition fadeWithDuration:SCENE_DURATION];
        [self.view presentScene:scene transition:transition];
    }
}

- (void)loadSceneToDone:(NSMutableDictionary *)params{
    [self loadSceneWithParam:_params[@"done"] params:params];
}



@end