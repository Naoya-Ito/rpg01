#import "rpg01OpeningScene.h"
#import "SKButtonNode.h"
#import "rpg01InputScene.h"
#import "rpg01PlayScene.h"
#import "rpg01SlimeNode.h"

@implementation rpg01OpeningScene

#define START_NAME @"start"
#define FIRE_NAME @"fire"
#define GREEN_FIRE_NAME @"green_fire"
#define BLUE_FIRE_NAME @"blue_fire"

- (void)createSceneContents
{
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.text = @"J・クエリーの秘宝";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:titleLabel];

    SKButtonNode *startButton = [SKButtonNode labelNodeWithFontNamed:titleLabel.fontName];
    startButton.text = @"はじめる";
    startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 30.0f);
    startButton.fontSize = 20.0f;
    startButton.hidden = YES;
    startButton.name = START_NAME;
    [self addChild:startButton];
    
    [self addSlime];
    [self addFire];
    [self addGreenFire];
    [self addBlueFire];

    // タイトルが上に動くアニメーション
    SKAction *wait = [SKAction waitForDuration:1.0f];
    SKAction *moveUp = [SKAction moveByX:0 y:50.0f duration:0.5f];
    SKAction *sequence = [SKAction sequence:@[wait, moveUp]];
    [titleLabel runAction:sequence completion:^{
        startButton.hidden = NO;
    }];
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
    } else if ([nodeAtPoint.name isEqualToString:FIRE_NAME]){
        NSMutableDictionary *params;
        params = [@{@"name": @"ikemen",
                    @"nickname": @"テスト戦士イケメン",                
                    @"HP" : @"23",
                    @"MP" : @"12",
                    @"str" : @"5",
                    @"def" : @"5",
                    @"int" : @"5",                    
                    @"story" : @"b1",
                    @"done" : @"title"
                    } mutableCopy];
        [self loadSceneWithParam:@"play" params:params];
    } else if ([nodeAtPoint.name isEqualToString:GREEN_FIRE_NAME]){
        NSMutableDictionary *params;
        params = [@{@"name": @"ikemen",
                    @"nickname": @"テスト戦士イケメン",
                    @"HP" : @"32",
                    @"MP" : @"34",
                    @"str" : @"12",
                    @"def" : @"13",
                    @"int" : @"14",
                    @"story" : @"b1",
                    @"done" : @"story"
                    } mutableCopy];
        [self loadSceneWithParam:@"play" params:params];
    } else if ([nodeAtPoint.name isEqualToString:BLUE_FIRE_NAME]){
        NSMutableDictionary *params;
        params = [@{@"name": @"ikemen",
                    @"nickname": @"テスト戦士イケメン",
                    @"HP" : @"100",
                    @"MP" : @"150",
                    @"gold" : @"10000",
                    @"str" : @"32",
                    @"def" : @"15",
                    @"int" : @"18",
                    @"story" : @"b1",
                    @"done" : @"title"
                    } mutableCopy];
        [self loadSceneWithParam:@"field" params:params];
    } else if ([nodeAtPoint.name isEqualToString:ENEMY_NAME]){
        NSMutableDictionary *params;
        params = [@{@"name": @"ikemen",
                    @"nickname": @"テスト戦士イケメン",
                    @"HP" : @"100",
                    @"MP" : @"150",
                    @"str" : @"32",
                    @"def" : @"15",
                    @"int" : @"18",
                    @"story" : @"b1",
                    @"done" : @"opening"
                    } mutableCopy];
        [self loadSceneWithParam:@"status" params:params];
    }
    [self touchesCancelled:touches withEvent:event];
}

@end
