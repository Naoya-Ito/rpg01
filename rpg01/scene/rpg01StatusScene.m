#import "rpg01StatusScene.h"

@implementation rpg01StatusScene

- (void)createSceneContents
{
    int exp = [_params[@"LV"] intValue] * 10;
    int gold = [_params[@"gold"] intValue];
    BOOL canLVUP = NO;
    if([_params[@"story"] isEqualToString:@"question_end"] || exp > gold){
        canLVUP = NO;
    } else {
        canLVUP = YES;
    }
    
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
    goldLabel.name = @"gold";
    goldLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 130.0f);
    [self addChild:goldLabel];
    
    SKLabelNode *expLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    expLabel.text = [NSString stringWithFormat:@"LVup必要GOLD：%d", [_params[@"LV"] intValue]*10];
    
    expLabel.name = @"exp";
    expLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 160.0f);
    [self addChild:expLabel];

    SKLabelNode *LVLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    LVLabel.text = [NSString stringWithFormat:@"LV:%@", _params[@"LV"]];
    LVLabel.name = @"LV";
    LVLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame) + 60.0f);
    [self addChild:LVLabel];
    
    SKLabelNode *HPLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    HPLabel.text = [NSString stringWithFormat:@"HP:%@", _params[@"HP"]];
    HPLabel.name = @"HP";
    HPLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame) + 30.0f);
    [self addChild:HPLabel];

    SKLabelNode *MPLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    MPLabel.text = [NSString stringWithFormat:@"MP:%@", _params[@"MP"]];
    MPLabel.name = @"MP";
    MPLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame));
    [self addChild:MPLabel];
    
    SKLabelNode *strLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    strLabel.text = [NSString stringWithFormat:@"筋力:%@", _params[@"str"]];
    strLabel.name = @"str";
    strLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame) - 30.0f);
    [self addChild:strLabel];

    SKLabelNode *defLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    defLabel.text = [NSString stringWithFormat:@"防御:%@", _params[@"def"]];
    defLabel.name = @"def";
    defLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame) - 60.0f);
    [self addChild:defLabel];
    
    SKLabelNode *intLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    intLabel.text = [NSString stringWithFormat:@"魔力:%@", _params[@"int"]];
    intLabel.name = @"int";
    intLabel.position = CGPointMake(80.0f, CGRectGetMidY(self.frame) - 90.0f);
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

    // ステータスアップボタン
    if(canLVUP){
        [self showStatusUpButton:@"HP" height:CGRectGetMidY(self.frame) + 40.0f];
        [self showStatusUpButton:@"MP" height:CGRectGetMidY(self.frame) + 10.0f];
        [self showStatusUpButton:@"str" height:CGRectGetMidY(self.frame) - 20.0f];
        [self showStatusUpButton:@"def" height:CGRectGetMidY(self.frame) - 50.0f];
        [self showStatusUpButton:@"int" height:CGRectGetMidY(self.frame) - 80.0f];
    }
}

-(void)showStatusUpButton:(NSString *)params height:(CGFloat)height{
    CGRect rect = CGRectMake(self.frame.size.width -  50.0f, height + 2.0f, 50.0f, 26.0f);
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:rect.size];
    square.position = rect.origin;
    square.name = [NSString stringWithFormat:@"%@UP", params];
    [self addChild:square];
    
    SKLabelNode *paramUPLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    paramUPLabel.fontColor = [SKColor blackColor];
    paramUPLabel.name = [NSString stringWithFormat:@"%@UP", params];
    paramUPLabel.text = @"UP";
    paramUPLabel.position = CGPointMake(self.frame.size.width -  50.0f, height - 10.0f);
    [self addChild:paramUPLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    
    if ([nodeAtPoint.name isEqual:@"back"]) {
        NSString *back = _params[@"done"];
        [self loadSceneWithParam:back params:_params];
    } else if ([nodeAtPoint.name isEqualToString:@"HPUP"]) {
        [self LVUP:@"HP"];
    } else if ([nodeAtPoint.name isEqualToString:@"MPUP"]) {
        [self LVUP:@"MP"];
    } else if ([nodeAtPoint.name isEqualToString:@"strUP"]) {
        [self LVUP:@"str"];
    } else if ([nodeAtPoint.name isEqualToString:@"defUP"]) {
        [self LVUP:@"def"];
    } else if ([nodeAtPoint.name isEqualToString:@"intUP"]) {
        [self LVUP:@"int"];
    }
}

- (void)LVUP:(NSString *)param{
    int exp = [_params[@"LV"] intValue]*10;
    if([_params[@"gold"] intValue] < exp){
        return;
    }
    _params[param] = [NSString stringWithFormat:@"%d",[_params[param] intValue] + 1];
    _params[@"gold"] = [NSString stringWithFormat:@"%d", [_params[@"gold"] intValue] - [_params[@"LV"] intValue] * 10];
    _params[@"LV"] = [NSString stringWithFormat:@"%d", [_params[@"LV"] intValue] + 1 ];
    
    exp = [_params[@"LV"] intValue]*10;
    

    SKLabelNode *LVLabel = (SKLabelNode *)[self childNodeWithName:@"LV"];
    LVLabel.text = [NSString stringWithFormat:@"LV:%@", _params[@"LV"]];
    
    SKLabelNode *goldLabel = (SKLabelNode *)[self childNodeWithName:@"gold"];
    goldLabel.text = [NSString stringWithFormat:@"所持金：%@", _params[@"gold"]];

    SKLabelNode *expLabel = (SKLabelNode *)[self childNodeWithName:@"exp"];
    expLabel.text = [NSString stringWithFormat:@"LVup必要GOLD：%d", exp];

    SKLabelNode *paramLabel = (SKLabelNode *)[self childNodeWithName:param];
    if([param isEqualToString:@"HP"]){
        paramLabel.text = [NSString stringWithFormat:@"HP:%@", _params[param]];
    } else if([param isEqualToString:@"MP"]){
        paramLabel.text = [NSString stringWithFormat:@"MP:%@", _params[param]];
    } else if([param isEqualToString:@"str"]){
        paramLabel.text = [NSString stringWithFormat:@"筋力:%@", _params[param]];
    } else if([param isEqualToString:@"def"]){
        paramLabel.text = [NSString stringWithFormat:@"防御:%@", _params[param]];
    } else if([param isEqualToString:@"int"]){
        paramLabel.text = [NSString stringWithFormat:@"魔力:%@", _params[param]];
    }
    if([_params[@"gold"] intValue] < exp){
        [self hiddenUPLabel:@"HPUP"];
        [self hiddenUPLabel:@"MPUP"];
        [self hiddenUPLabel:@"strUP"];
        [self hiddenUPLabel:@"defUP"];
        [self hiddenUPLabel:@"intUP"];
    }
}

- (void)hiddenUPLabel:(NSString *)param{
    SKLabelNode *upLabel = (SKLabelNode *)[self childNodeWithName:param];
    upLabel.hidden = YES;
}

- (void)update:(NSTimeInterval)currentTime {

}


@end
