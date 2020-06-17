#import <Foundation/Foundation.h>

@interface Vision360Beans : NSObject
@property(nonatomic,strong) NSString *message;
@property(nonatomic) float totalPre;
@property(nonatomic) float totalDesc;
@property (nonatomic) BOOL success;
@property (nonatomic) BOOL isEvent;
@property(nonatomic,strong) NSMutableArray *event;
@property(nonatomic,strong) NSMutableArray *assists;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
