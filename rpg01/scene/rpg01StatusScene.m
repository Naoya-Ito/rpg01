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
    nameLabel.text = [NSString stringWithFormat:@"%@%@%@", _params[@"nickname"], _params[@"job"], _params[@"name"]];
    nameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 80.0f);
    [self addChild:nameLabel];

    SKLabelNode *goldLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    goldLabel.text = [NSString stringWithFormat:@"所持金：%@", _params[@"gold"]];
    goldLabel.name = @"gold";
    goldLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 130.0f);
    [self addChild:goldLabel];

    [self displayColumn:@"LV" displayName:@"LV" height:310.0f];
    [self displayColumn:@"HP" displayName:@"HP" height:270.0f];
    [self displayColumn:@"MP" displayName:@"MP" height:230.0f];
    [self displayColumn:@"str" displayName:@"筋力" height:190.0f];
    [self displayColumn:@"int" displayName:@"魔力" height:150.0f];
    [self displayColumn:@"luck" displayName:@"幸運" height:110.0f];
    
    // 戻るボタン
    CGPoint point = CGPointMake(CGRectGetMidX(self.frame), 80.0f);
    if([_params[@"story"] isEqualToString:@"question_end"]){
        [self makeButton:point name:@"back" text:@"次へ"];
    } else {
        [self makeButton:point name:@"back" text:@"戻る"];
    }

    // ステータスアップボタン
    if(canLVUP){
        SKLabelNode *expLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
        expLabel.text = [NSString stringWithFormat:@"LVupに必要な金：%d", [_params[@"LV"] intValue]*10];
        expLabel.name = @"exp";
        expLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 180.0f);
        [self addChild:expLabel];
        
        CGPoint point;
        if([_params[@"HP"] intValue] < 150){
            point = CGPointMake(self.frame.size.width -  150.0f, 320.0f);
            [self makeButton:point name:@"HPUP" text:@"UP"];
        }
        if([_params[@"MP"] intValue] < 50){
            point = CGPointMake(self.frame.size.width -  150.0f, 280.0f);
            [self makeButton:point name:@"MPUP" text:@"UP"];
        }

        if([_params[@"str"] intValue] < 999){
            point = CGPointMake(self.frame.size.width -  150.0f, 240.0f);
            [self makeButton:point name:@"strUP" text:@"UP"];
        }
        if([_params[@"int"] intValue] < 50){
            point = CGPointMake(self.frame.size.width -  150.0f, 200.0f);
            [self makeButton:point name:@"intUP" text:@"UP"];
        }
        if([_params[@"luck"] intValue] < 30){
            point = CGPointMake(self.frame.size.width -  150.0f, 160.0f);
            [self makeButton:point name:@"luckUP" text:@"UP"];
        }
    }
}

- (void)displayColumn:(NSString *)name displayName:(NSString *)displayName height:(CGFloat)height{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    label.text = [NSString stringWithFormat:@"%@:%@", displayName, _params[name]];
    label.name = name;
    label.position = CGPointMake(20.0f, height);
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:label];
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
    if([param isEqualToString:@"HP"]){
        _params[@"HP"] = [NSString stringWithFormat:@"%d",[_params[@"HP"] intValue] + 5];
    } else {
        _params[param] = [NSString stringWithFormat:@"%d",[_params[param] intValue] + 1];
    }
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
    if([_params[@"HP"] intValue] >= 150){
        [self hiddenUPLabel:@"HPUP"];
        _params[@"HP"] = @"150";
    }
    if([_params[@"MP"] intValue] >= 50){
        [self hiddenUPLabel:@"MPUP"];
        _params[@"HP"] = @"50";
    }
}

- (void)hiddenUPLabel:(NSString *)param{
    SKLabelNode *upLabel = (SKLabelNode *)[self childNodeWithName:param];
    upLabel.hidden = YES;
}

- (void)update:(NSTimeInterval)currentTime {

}


@end
