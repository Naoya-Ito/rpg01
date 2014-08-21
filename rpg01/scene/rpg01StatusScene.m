#import "rpg01StatusScene.h"

@implementation rpg01StatusScene

- (void)createSceneContents
{
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.text = @"ステータス";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) + 30.0f);
    [self addChild:titleLabel];

    SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    nameLabel.text = [NSString stringWithFormat:@"%@", _params[@"nickname"]];
    nameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 80.0f);
    [self addChild:nameLabel];

    SKLabelNode *goldLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    goldLabel.text = [NSString stringWithFormat:@"所持金：%@", _params[@"gold"]];
    goldLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 130.0f);
    [self addChild:goldLabel];

    SKLabelNode *LVLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    LVLabel.text = [NSString stringWithFormat:@"LV:%@", _params[@"LV"]];
    LVLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame) + 60.0f);
    [self addChild:LVLabel];
    
    SKLabelNode *HPLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    HPLabel.text = [NSString stringWithFormat:@"HP:%@/%@", _params[@"currentHP"],_params[@"HP"]];
    HPLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame) + 30.0f);
    [self addChild:HPLabel];

    SKLabelNode *MPLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    MPLabel.text = [NSString stringWithFormat:@"MP:%@", _params[@"MP"]];
    MPLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame));
    [self addChild:MPLabel];
    
    SKLabelNode *strLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    strLabel.text = [NSString stringWithFormat:@"筋力:%@", _params[@"str"]];
    strLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame) - 30.0f);
    [self addChild:strLabel];

    SKLabelNode *defLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    defLabel.text = [NSString stringWithFormat:@"防御:%@", _params[@"def"]];
    defLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame) - 60.0f);
    [self addChild:defLabel];
    
    SKLabelNode *intLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    intLabel.text = [NSString stringWithFormat:@"魔力:%@", _params[@"int"]];
    intLabel.position = CGPointMake(150.0f, CGRectGetMidY(self.frame) - 90.0f);
    [self addChild:intLabel];
    
    // 戻るボタン
    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    backButton.color = [SKColor greenColor];
    if([_params[@"story"] isEqualToString:@"question_end"]){
        backButton.text = @"次へ";
    } else {
        backButton.text = @"戻る";
    }
    backButton.position = CGPointMake(CGRectGetMidX(self.frame), 80.0f);
    backButton.fontSize = FONT_SIZE;
    backButton.name = @"back";
    [self addChild:backButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if ([nodeAtPoint.name isEqual:@"back"]) {
        NSString *back = _params[@"done"];
        [self loadSceneWithParam:back params:_params];
    }
}

@end
