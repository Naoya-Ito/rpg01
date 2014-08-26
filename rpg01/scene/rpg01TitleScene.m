#import "rpg01TitleScene.h"
#import "SKMessageNode.h"

static const CGFloat MARGIN = 100.0f;
static const CGFloat DELAY = 5.0f;

@implementation rpg01TitleScene

- (void)createSceneContents {
    // タイトル
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.fontSize = 20.0f;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + MARGIN);
    titleLabel.verticalAlignmentMode =SKLabelVerticalAlignmentModeBottom;

    // 副題
    SKLabelNode *subTitleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    subTitleLabel.fontSize = FONT_SIZE;
    subTitleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + MARGIN - 40.0f);
    subTitleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    
    SKMessageNode *message = [[SKMessageNode alloc] initWithNoBox:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    [self addChild:message];

    if([_params[@"story"] isEqualToString:@"chapter1"]){
        titleLabel.text = @"第一章 モンスター軍　襲来";
        [self messageNode].message = @"時は20XX年。人々はモンスターの脅威にさらされていた。";
        [self performSelector:@selector(nextSceneFromChapter1) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"b1"]){
        titleLabel.text = @"防衛１日目　恐怖のスライム軍";
        subTitleLabel.text = @"クリア条件：20秒間町を守り続けろ！";
        [self messageNode].message = @"タップをすればそこに主人公が移動する。剣マークをタップして攻撃してスライムを倒すべし！";
        [self performSelector:@selector(nextSceneFromB1) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"b2"]){
        titleLabel.text = @"防衛二日目　空からの恐怖";
        subTitleLabel.text = @"クリア条件：20秒間耐え続けろ";
        [self messageNode].message = @"MPを消費して魔法を唱えるべし。剣攻撃を当てればMPが回復するのだ。";
        [self performSelector:@selector(nextSceneFromB2) withObject:nil afterDelay:DELAY];
    } else if([_params[@"story"] isEqualToString:@"b3"]){
        titleLabel.text = @"地下3階　動く屍";
        subTitleLabel.text = @"クリア条件：ボス（スケルトン）を倒せ";
        [self messageNode].message = @"スケルトンは物理攻撃が効かない。魔法で攻めるべし。";
        [self performSelector:@selector(nextSceneFromB3) withObject:nil afterDelay:DELAY];
    }

    [self addChild:titleLabel];
    [self addChild:subTitleLabel];
}

- (SKMessageNode *)messageNode {
    return (SKMessageNode *)[self childNodeWithName:kMessageName];
}

- (void)nextSceneFromChapter1{
    [self loadSceneWithParam:@"input" params:_params];
}

- (void)nextSceneFromB1{
    _params[@"story"] = @"b1";
    _params[@"done"] = @"title";
    [self loadSceneWithParam:@"play" params:_params];
}

- (void)nextSceneFromB2{
    _params[@"story"] = @"b2";
    [self loadSceneWithParam:@"play" params:_params];
}

- (void)nextSceneFromB3{
    _params[@"story"] = @"b3";
    [self loadSceneWithParam:@"play" params:_params];
}

@end
