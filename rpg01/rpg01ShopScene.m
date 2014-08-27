#import "rpg01ShopScene.h"

@implementation rpg01ShopScene

- (void)createSceneContents{
    CGPoint point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 310.0f);
    CGSize size = CGSizeMake(80, 28);
    int cost = 200;
    [self makeButtonWithSize:point name:@"cons" text:@"集中" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"炎の飛距離と速度アップ"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 270.0f);
    cost = 200;
    [self makeButtonWithSize:point name:@"wakeUp" text:@"覚醒" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"炎の大きさアップ"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 230.0f);
    cost = 350;
    [self makeButtonWithSize:point name:@"study" text:@"悟り" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"MP回復量アップ"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 190.0f);
    cost = 350;
    [self makeButtonWithSize:point name:@"master" text:@"極意" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"MP消費量が5から4になる"];
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 150.0f);
    cost = 350;
    [self makeButtonWithSize:point name:@"study" text:@"乱れ斬り" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"斬る回数が増える"];

    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 110.0f);
    cost = 350;
    [self makeButtonWithSize:point name:@"study" text:@"心眼" size:size];
    [self outputCost:point text:[NSString stringWithFormat:@"%d",cost]];
    [self outputDescription:point text:@"最低ダメージが２になる"];

    
    
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 30.0f);
    [self makeButton:point name:@"back" text:@"戻る"];
}

- (void)outputCost:(CGPoint)point text:(NSString*)text{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.text = text;
    textLabel.position = CGPointMake(point.x + 50.0f, point.y - 5.0f);
    textLabel.fontSize = 14.0f;
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textLabel.color = [SKColor whiteColor];
    [self addChild:textLabel];
}

- (void)outputDescription:(CGPoint)point text:(NSString*)text{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.text = text;
    textLabel.position = CGPointMake(point.x + 100.0f, point.y - 5.0f);
    textLabel.fontSize = 14.0f;
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textLabel.color = [SKColor whiteColor];
    [self addChild:textLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    if ([nodeAtPoint.name isEqualToString:@"cons"]) {
        _params[@"cons"] = @"OK";
    } else if ([nodeAtPoint.name isEqualToString:@"wakeUp"]) {
        _params[@"wakeUp"] = @"OK";
    } else if ([nodeAtPoint.name isEqualToString:@"back"]) {
        [self loadSceneWithParam:@"field" params:_params];
    }
}

@end
