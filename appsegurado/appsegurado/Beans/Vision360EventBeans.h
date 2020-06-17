#import <Foundation/Foundation.h>



typedef enum : NSUInteger {
    NSEvent,
    NSAssist,
} NSEventType;


@interface Vision360EventBeans : NSObject
@property(strong, nonatomic) NSString *dateOc;
@property(strong, nonatomic) NSString *description;
@property(strong, nonatomic) NSString *image;
@property(nonatomic) float valueFranq;
@property(nonatomic) float value;
@property(nonatomic) NSEventType type;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
