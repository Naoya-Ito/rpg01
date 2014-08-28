#import "rpg01LibraryScene.h"
#import "rpg01SlimeNode.h"
#import "rpg01CatNode.h"
#import "rpg01BatNode.h"
#import "rpg01GhostNode.h"
#import "rpg01SkeltonNode.h"
#import "rpg01DragonNode.h"
#import "rpg01DarkNode.h"
#import "rpg01BigCatNode.h"
#import "rpg01GolemNode.h"

@implementation rpg01LibraryScene

- (void)createSceneContents{
    [self addStatusFrame];
    
    if([_params[@"page"] isEqualToString:@"2"]){
        CGPoint point = CGPointMake(150.0f, 430.0f);
        rpg01BigCatNode *bigCat = [rpg01BigCatNode bigCat];
        bigCat.position = point;
        bigCat.physicsBody.dynamic = NO;
        [self addChild:bigCat];
        
        point = CGPointMake( 20.0, 320);
        SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        textLabel.text = [NSString stringWithFormat:@"%@　HP:%@　力:%@　GOLD:%@", bigCat.userData[@"name"], bigCat.userData[@"life"] , bigCat.userData[@"str"], bigCat.userData[@"exp"]];
        textLabel.position = point;
        textLabel.fontSize = 14.0f;
        textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        textLabel.color = [SKColor whiteColor];
        [self addChild:textLabel];
        
        point = CGPointMake( 20.0, 300);
        SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        text.text = @"画像提供：栗茶屋様。　圧倒的でかさ。";
        text.position = point;
        text.fontSize = 14.0f;
        text.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text.color = [SKColor whiteColor];
        [self addChild:text];
        
        point = CGPointMake(150.0f, 250.0f);
        rpg01GolemNode *golem = [rpg01GolemNode golem];
        golem.position = point;
        golem.physicsBody.dynamic = NO;
        [self addChild:golem];
        
        point = CGPointMake( 20.0, 170);
        SKLabelNode *textLabel2 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        textLabel2.text = [NSString stringWithFormat:@"%@　HP:%@　力:%@　GOLD:%@", golem.userData[@"name"], golem.userData[@"life"] , golem.userData[@"str"], golem.userData[@"exp"]];
        textLabel2.position = point;
        textLabel2.fontSize = 14.0f;
        textLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        textLabel2.color = [SKColor whiteColor];
        [self addChild:textLabel2];
        
        point = CGPointMake( 20.0, 150);
        SKLabelNode *text2 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        text2.text = @"画像提供：ぴぽや様。　魔法しか効かない。";
        text2.position = point;
        text2.fontSize = 14.0f;
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text2.color = [SKColor whiteColor];
        [self addChild:text2];
        
        point = CGPointMake( 40.0, 90);
        text2 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        text2.text = @"BGM：PANICPUMPKIN 様";
        text2.position = point;
        text2.fontSize = 14.0f;
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text2.color = [SKColor whiteColor];
        [self addChild:text2];
        
        point = CGPointMake(250.0f, 50.0f);
        [self makeButton:point name:@"next2" text:@"次へ"];
    } else if([_params[@"page"] isEqualToString:@"3"]){
        CGPoint point = CGPointMake(40.0f, 490.0f);
        rpg01CatNode *cat = [rpg01CatNode goldCat];
        cat.position = point;
        cat.physicsBody.dynamic = NO;
        [self addChild:cat];
        [self outputParameter:point text:@"経験値を超くれるネコ。" node:cat];
        
        point = CGPointMake(40.0f, 440.0f);
        rpg01GhostNode *ghost = [rpg01GhostNode blueGhost];
        ghost.position = point;
        ghost.physicsBody.dynamic = NO;
        [self addChild:ghost];
        [self outputParameter:point text:@"青ざめても魔法しか効かない。" node:ghost];
    } else {
        CGPoint point = CGPointMake(40.0f, 490.0f);
        rpg01SlimeNode *slime = [rpg01SlimeNode slime];
        slime.position = point;
        slime.physicsBody.dynamic = NO;
        [self addChild:slime];
        [slime slimeAnimation];
        [self outputParameter:point text:@"雑魚キャラ。プニプ二してる。" node:slime];

        point = CGPointMake(40.0f, 440.0f);
        rpg01CatNode *cat = [rpg01CatNode cat];
        cat.position = point;
        cat.physicsBody.dynamic = NO;
        [self addChild:cat];
        [self outputParameter:point text:@"足が速い。でも弱い。" node:cat];

        point = CGPointMake(40.0f, 390.0f);
        rpg01BatNode *bat = [rpg01BatNode bat];
        bat.position = point;
        bat.physicsBody.dynamic = NO;
        [self addChild:bat];
        [bat fly];
        [self outputParameter:point text:@"横に動く。でも弱い。" node:bat];
        
        point = CGPointMake(40.0f, 340.0f);
        rpg01GhostNode *ghost = [rpg01GhostNode ghost];
        ghost.position = point;
        ghost.physicsBody.dynamic = NO;
        [self addChild:ghost];
        [self outputParameter:point text:@"ションボリ。物理攻撃が効かない。" node:ghost];

        point = CGPointMake(40.0f, 280.0f);
        rpg01SkeltonNode *skelton = [rpg01SkeltonNode skelton];
        skelton.position = point;
        skelton.physicsBody.dynamic = NO;
        [self addChild:skelton];
        [skelton skeltonMove];
        [self outputParameter:point text:@"動きが速い強敵。" node:skelton];

        point = CGPointMake(40.0f, 210.0f);
        rpg01DragonNode *dragon = [rpg01DragonNode dragon];
        dragon.position = point;
        dragon.physicsBody.dynamic = NO;
        [self addChild:dragon];
        [self outputParameter:point text:@"動きは遅いけど強い。 HP高すぎ。" node:dragon];
        
        point = CGPointMake(40.0f, 150.0f);
        rpg01SlimeNode *greenSlime = [rpg01SlimeNode greenSlime];
        greenSlime.position = point;
        greenSlime.physicsBody.dynamic = NO;
        [self addChild:greenSlime];
        [self outputParameter:point text:@"攻撃力が高いスライム。超プニプ二。" node:greenSlime];

        point = CGPointMake(40.0f, 100.0f);
        rpg01DarkNode *dark = [rpg01DarkNode dark];
        dark.position = point;
        dark.physicsBody.dynamic = NO;
        [self addChild:dark];
        [greenSlime greenSlimeAnimation];
        [self outputParameter:point text:@"動きが超速くて魔法しか効かない。" node:dark];
        
        point = CGPointMake(250.0f, 50.0f);
        [self makeButton:point name:@"next" text:@"次へ"];
    }

    [self makeButton:CGPointMake(50.0f, 50.0f) name:@"back" text:@"戻る"];    
}

- (void)outputParameter:(CGPoint)point text:(NSString*)text node:(SKSpriteNode*)node{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.text = [NSString stringWithFormat:@"%@　HP:%@　力:%@　GOLD:%@", node.userData[@"name"], node.userData[@"life"] , node.userData[@"str"], node.userData[@"exp"]];
    textLabel.position = CGPointMake(point.x + 38.0f, point.y);
    textLabel.fontSize = 14.0f;
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textLabel.color = [SKColor whiteColor];
    [self addChild:textLabel];
    
    SKLabelNode *text2 = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    text2.text = text;
    text2.position = CGPointMake(point.x + 38.0f, point.y - 20.0f);
    text2.fontSize = 14.0f;
    text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    text2.color = [SKColor whiteColor];
    [self addChild:text2];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if ([nodeAtPoint.name isEqualToString:@"next"]) {
        _params[@"page"] = @"2";
        [self loadSceneWithParam:@"library" params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"next2"]) {
        _params[@"page"] = @"3";
        [self loadSceneWithParam:@"library" params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"back"]) {
        _params[@"page"] = @"1";
        [self loadSceneWithParam:@"field" params:_params];
    }
}

@end
