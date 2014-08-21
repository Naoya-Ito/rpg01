#import <SpriteKit/SpriteKit.h>

#import "rpg01Utilities.h"

extern NSString * const kMapName;
extern NSString * const kPlayerName;

extern const uint32_t playerCategory;
extern const uint32_t characterCategory;

@interface rpg01MapNode : SKNode

- (id)initWithMapNamed:(NSString *)name base_height:(double)base_height;
    
@end
