#import "rpg01GameOverScene.h"

@implementation rpg01GameOverScene

- (void)createSceneContents {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:FONT_NORMAL];
    titleLabel.text = @"GAME OVER";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:titleLabel];

    SKMessageNode *message = [[SKMessageNode alloc] initWithSize:CGSizeMake(self.size.width, self.size.height * 0.3f)];
    message.message = [self randomText];
    [self addChild:message];
    
    [self performSelector:@selector(_goTitle) withObject:Nil afterDelay:6.0f];
    
    [self stopBGM];
}

- (void)_goTitle {
    [self loadScene:@"opening"];
}

- (NSString *)randomText {
    NSString *message;

    CGFloat rand = arc4random() % 8;
    if(rand == 0 ){
        message = @"残念、君の冒険はここで終わってしまった！";
    } else if (rand == 1){
        message = @"「そんな、バカな……」　その言葉が君の最後の言葉となった。";
    } else if (rand == 2){
        message = @"志半ばで君の命は尽きた……。無念の涙が頬を伝う。";
    } else if (rand == 3){
        message = @"「いやだ、死にたくない！」　君は死に際に叫んだ。しかし無慈悲な死神は君の願いを聞き入れるはずもなかった……。";
    } else if (rand == 4){
        message = @"君は致命傷を負った。流れる血は止める事ができず、確実な死が目前に迫っていた……。";
    } else if (rand == 5){
        message = @"「うわー！」　死に際に情けない悲鳴が聞こえた。その悲鳴をあげたのが自分だと気づいた時には君の心臓は止まっていた。";
    } else if (rand == 6){
        message = @"「もはやここまでか……」　君は冒険に出た時から死の覚悟はできていた。悲鳴もあげず、潔く君は死んだ。";
    } else if (rand == 7){
        message = @"「我が生涯に悔いは無し！」　君は誰よりも格好良く死んだ。";
    } else {
        message = @"死んじゃったよーん";
    }
    
    return message;
}

@end
