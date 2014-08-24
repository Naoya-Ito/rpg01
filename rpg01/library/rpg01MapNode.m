#import "rpg01MapNode.h"

static NSString * const FILE_TYPE = @"csv";

const uint32_t playerCategory = 0x1 << 0;
const uint32_t characterCategory = 0x1 << 1;

@implementation rpg01MapNode {
    NSString *_name;
    double _base_height;
}

- (id)initWithMapNamed:(NSString *)name base_height:(double)base_height{
    if (self = [super init]) {
        _name = name;
        _base_height = base_height;
        [self createNodeContents];
    }
    return self;
}

- (void)createNodeContents {
    // map情報の書かれたcsvを読み込む
    NSString *mapData = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_name ofType:FILE_TYPE]  encoding:NSUTF8StringEncoding error:nil];

    NSArray *layers = [mapData componentsSeparatedByString:@"\n\n"];
    for (NSString *layer in layers) {
        NSString *trimmedLayer = [layer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *rows = [[[trimmedLayer componentsSeparatedByString:@"\n"] reverseObjectEnumerator] allObjects];
        for (int i = 0; i < rows.count; i++) {
            NSString *row = rows[i];
            row = [row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *cols = [row componentsSeparatedByString:@","];
            for (int j = 0; j < cols.count; j++) {
                NSString *col = cols[j];
                SKSpriteNode *tileSprite;
                
                if ([col isEqualToString:@"x"]) continue;
                
                if ([col isEqualToString:@"0"]){
                    tileSprite = [SKSpriteNode spriteNodeWithImageNamed:@"yuka"];
                    tileSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
                    tileSprite.physicsBody.dynamic = NO;
                    tileSprite.physicsBody.categoryBitMask = worldCategory;
                    tileSprite.physicsBody.collisionBitMask = heroCategory;
                    tileSprite.physicsBody.usesPreciseCollisionDetection = YES;
                } else if ([col isEqualToString:@"1"]){
                     tileSprite = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(TILE_SIZE, TILE_SIZE)];
                } else if ([col isEqualToString:@"2"]){
                    tileSprite = [SKSpriteNode spriteNodeWithImageNamed:@"yuka_shop"];
                } else if ([col isEqualToString:@"3"]){
                    tileSprite = [SKSpriteNode spriteNodeWithImageNamed:@"house"];
                    tileSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
                    tileSprite.physicsBody.dynamic = NO;
                    tileSprite.physicsBody.categoryBitMask = houseCategory;
                    tileSprite.physicsBody.usesPreciseCollisionDetection = YES;
                } else {
                    NSLog(@"invalid col, %@", col);
                }

                 tileSprite.position = CGPointMake(j * TILE_SIZE + TILE_SIZE / 2.0f, i * TILE_SIZE + TILE_SIZE / 2.0f + _base_height);
                [self addChild:tileSprite];
            }
        }
    }
}

@end
