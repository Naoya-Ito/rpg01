#import "rpg01ShopScene.h"

const int COST_CONS = 300;
const int COST_WAKEUP = 300;
const int COST_BLUE = 600;
const int COST_MIDARE = 200;
const int COST_SPEED = 150;

const int KAERE_TAG = 0;
const int BUY_TAG = 1;

@implementation rpg01ShopScene{
    int _currentCost;
    NSString *_currentName;
    NSString *_currentDisplayName;
}

- (void)createSceneContents{
    [self addStatusFrame];
    
    CGPoint point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 310.0f);
    CGSize size = CGSizeMake(80, 28);
    if(![_params[@"cons"] isEqualToString:@"OK"]){
        [self makeButtonWithSize:point name:@"cons" text:@"集中" size:size];
        [self outputCost:point text:[NSString stringWithFormat:@"%d", COST_CONS] name:@"cons"];
        [self outputDescription:point text:@"炎の飛距離と速度アップ" name:@"cons"];
    }
    if(![_params[@"wakeUp"] isEqualToString:@"OK"]){
        point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 270.0f);
        [self makeButtonWithSize:point name:@"wakeUp" text:@"覚醒" size:size];
        [self outputCost:point text:[NSString stringWithFormat:@"%d",COST_WAKEUP] name:@"wakeUp"];
        [self outputDescription:point text:@"炎の大きさアップ" name:@"wakeUp"];
    }
    if(![_params[@"blue"] isEqualToString:@"OK"]){
        point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 230.0f);
        [self makeButtonWithSize:point name:@"blue" text:@"蒼炎" size:size];
        [self outputCost:point text:[NSString stringWithFormat:@"%d", COST_BLUE] name:@"blue"];
        [self outputDescription:point text:@"魔法ダメージ２倍" name:@"blue"];
    }
    
    if(![_params[@"midare"] isEqualToString:@"OK"]){
        point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 190.0f);
        [self makeButtonWithSize:point name:@"midare" text:@"乱れ斬り" size:size];
        [self outputCost:point text:[NSString stringWithFormat:@"%d", COST_MIDARE] name:@"midare"];
        [self outputDescription:point text:@"斬る回数が増える" name:@"midare"];
    }
    
    if(![_params[@"speed"] isEqualToString:@"OK"]){
        point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 150.0f);
        [self makeButtonWithSize:point name:@"speed" text:@"縮地" size:size];
        [self outputCost:point text:[NSString stringWithFormat:@"%d", COST_SPEED] name:@"speed"];
        [self outputDescription:point text:@"目にも止まらぬ早さになる" name:@"speed"];
    } else {
        point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 150.0f);
        [self makeButtonWithSize:point name:@"speedCancel" text:@"縮地解除" size:size];
        [self outputDescription:point text:@"普通の早さに戻す" name:@"speed"];
    }
    point = CGPointMake(50.0f, self.frame.size.height * 0.3 + 30.0f);
    [self makeButton:point name:@"back" text:@"戻る"];
}

- (void)outputCost:(CGPoint)point text:(NSString*)text name:(NSString *)name{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.name = [NSString stringWithFormat:@"%@_cost", name];
    textLabel.text = text;
    textLabel.position = CGPointMake(point.x + 50.0f, point.y - 5.0f);
    textLabel.fontSize = 14.0f;
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textLabel.color = [SKColor whiteColor];
    [self addChild:textLabel];
}

- (void)outputDescription:(CGPoint)point text:(NSString*)text name:(NSString *)name{
    SKLabelNode *textLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    textLabel.name = [NSString stringWithFormat:@"%@_d", name];
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
        if(![_params[@"cons"] isEqualToString:@"OK"]){
            _currentName = @"cons";
            _currentDisplayName = @"集中";
            _currentCost = COST_MIDARE;
            [self buy];
        }
    } else if ([nodeAtPoint.name isEqualToString:@"wakeUp"]) {
        if(![_params[@"wakeUp"] isEqualToString:@"OK"]){
            _currentName = @"wakeUp";
            _currentCost = COST_WAKEUP;
            _currentDisplayName = @"覚醒";
            [self buy];
        }
    } else if ([nodeAtPoint.name isEqualToString:@"blue"]) {
        if(![_params[@"blue"] isEqualToString:@"OK"]){
            _currentName = @"blue";
            _currentCost = COST_BLUE;
            _currentDisplayName = @"蒼炎";
            [self buy];
        }
    } else if ([nodeAtPoint.name isEqualToString:@"speed"]) {
        if(![_params[@"speed"] isEqualToString:@"OK"]){
            _currentName = @"speed";
            _currentDisplayName = @"乱れ斬り";
            _currentCost = COST_SPEED;
            [self buy];
        }
    } else if ([nodeAtPoint.name isEqualToString:@"midare"]) {
        if(![_params[@"midare"] isEqualToString:@"OK"]){
            _currentName = @"midare";
            _currentDisplayName = @"乱れ斬り";
            _currentCost = COST_MIDARE;
            [self buy];
        }
    } else if ([nodeAtPoint.name isEqualToString:@"speedCancel"]) {
        _params[@"speed"] = @"NO";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"縮地を取り消しました" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"さんくす！", nil];
        alertView.tag = KAERE_TAG;
        [alertView show];
    } else if ([nodeAtPoint.name isEqualToString:@"back"]) {
        [self loadSceneWithParam:@"field" params:_params];
    }
}

-(void)buy{
    int gold = [_params[@"gold"] intValue];
    
    if(gold < _currentCost){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"おいおい、金が足りないぜ" message:@"店員は白い目で君を見つめている。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"し、失礼しました", nil];
        alertView.tag = KAERE_TAG;
        [alertView show];
    } else {
        NSString *text = [NSString stringWithFormat:@"%@か。%dゴールドになるぜ", _currentDisplayName, _currentCost];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"やっぱいらないや。" otherButtonTitles:@"買った！", nil];
        alertView.tag = BUY_TAG;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == BUY_TAG){
        switch (buttonIndex) {
            case 0:   // キャンセル
                _params[@"nickname"] = @"嫌な客";
                break;
            case 1:   // 買った！
                _params[_currentName] = @"OK";
                SKLabelNode *goodsLabel = (SKLabelNode *)[self childNodeWithName:_currentName];
                goodsLabel.hidden = YES;
                SKLabelNode *costLabel = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat:@"%@_cost",_currentName]];
                costLabel.hidden = YES;
                SKLabelNode *dLabel = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat:@"%@_d", _currentName]];
                dLabel.hidden = YES;
                _params[@"gold"] = [NSString stringWithFormat:@"%d", [_params[@"gold"] intValue] - _currentCost];
                [self outputGold];                
                break;
        }
    }
}


@end
