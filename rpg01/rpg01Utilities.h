#import <Foundation/Foundation.h>

extern const CGFloat TILE_SIZE;
static NSString * const FONT_NORMAL = @"";
static const CGFloat FONT_SIZE = 16.0f;

static const CGFloat HERO_SPEED = 1.5f;

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t swordCategory = 0x1 << 1;
static const uint32_t enemyCategory = 0x1 << 2;
static const uint32_t boxCategory = 0x1 << 3;
static const uint32_t slimeCategory = 0x1 << 4;
static const uint32_t doorCategory = 0x1 << 5;
static const uint32_t sisterCategory = 0x1 << 6;
static const uint32_t worldCategory = 0x1 << 7;


static NSString * const HERO_NAME = @"hero";
static NSString * const ENEMY_NAME = @"enemy";
static NSString * const ENEMY_BAT_NAME = @"bat";
static NSString * const ENEMY_SKELTON_NAME = @"skelton";
static NSString * const TIME_NAME = @"time";
static NSString * const HP_NAME = @"hp";
static NSString * const SCORE_NAME = @"score";
static NSString * const BALL_NAME = @"ball";
static NSString * const WEAPON_NAME = @"weapon";
static NSString * const DOOR_NAME = @"door";
static NSString * const SISTER_NAME = @"sister";

@interface rpg01Utilities : NSObject

@end
