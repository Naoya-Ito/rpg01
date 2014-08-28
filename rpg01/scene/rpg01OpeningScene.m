#import "rpg01OpeningScene.h"
#import "SKButtonNode.h"
#import "rpg01InputScene.h"
#import "rpg01PlayScene.h"
#import "rpg01SlimeNode.h"
#import "rpg01HeroNode.h"
#import "rpg01GhostNode.h"

@implementation rpg01OpeningScene

#define START_NAME @"start"
#define FIRE_NAME @"fire"
#define GREEN_FIRE_NAME @"green_fire"
#define BLUE_FIRE_NAME @"blue_fire"

- (void)createSceneContents
{
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.text = @"戦場の勇者";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100.0f);
    [self addChild:titleLabel];
    
    [self makeButton:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 10.0f) name:START_NAME text:@"はじめる" ];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"params"]){
        NSDictionary *dict =  [defaults dictionaryForKey:@"params"];
        _params = [dict mutableCopy];

        [self makeButton:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 70.0f) name:@"continue" text:@"つづき"];
    }
    
    rpg01HeroNode *hero = [rpg01HeroNode hero];
    hero.position = CGPointMake(100.0, CGRectGetMidY(self.frame) - 60.0f);
    [hero walkRight];
    [self addChild:hero];

    rpg01GhostNode *ghost = [rpg01GhostNode ghost];
    ghost.position = CGPointMake(CGRectGetMidX(self.frame) + 100.0f, CGRectGetMidY(self.frame));
    ghost.physicsBody.dynamic = NO;
    [self addChild:ghost];
    
    [self addSlime];
    [self addFire];
    [self addGreenFire];
    [self addBlueFire];
}

- (void)addFire{
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.xScale = fire.yScale = 0.3f;
    fire.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 60.0f);
    fire.name = FIRE_NAME;
    [self addChild:fire];
}

- (void)addGreenFire{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"green_fire" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    node.xScale = node.yScale = 0.3f;
    node.position = CGPointMake(CGRectGetMidX(self.frame)/2*3, CGRectGetMinY(self.frame) + 60.0f);
    node.name = GREEN_FIRE_NAME;
    [self addChild:node];
}

- (void)addBlueFire{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"blue_fire" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    node.xScale = node.yScale = 0.3f;
    node.position = CGPointMake(CGRectGetMidX(self.frame)/2, CGRectGetMinY(self.frame) + 60.0f);
    node.name = BLUE_FIRE_NAME;
    [self addChild:node];
}

- (void)addSlime{
    rpg01SlimeNode *slime = [rpg01SlimeNode slime];
    slime.position = CGPointMake(CGRectGetMidX(self.frame) + 60.0f, CGRectGetMidY(self.frame) - 60.0f);
    [self addChild:slime];
    [slime slimeAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if ([nodeAtPoint.name isEqualToString:START_NAME]) {
        NSMutableDictionary *params;
        params = [@{
                    @"story" : @"chapter1"
                    } mutableCopy];
        [self loadSceneWithParam:@"title" params:params];
    } else if ([nodeAtPoint.name isEqualToString:@"continue"]){
        [self loadSceneWithParam:@"field" params:_params];
    }
    [self touchesCancelled:touches withEvent:event];
}

@end
