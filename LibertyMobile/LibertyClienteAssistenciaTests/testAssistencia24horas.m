//
//  testAssistencia24horas.m
//  LibertyMobile
//
//  Created by EvandroO on 08/05/14.
//
//

#import <XCTest/XCTest.h>

#import <DirectAssistLib/DADevice.h>

@interface testAssistencia24horas : XCTestCase

@end

@implementation testAssistencia24horas

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testGloballyUniqueString
{
    DADevice *dADevice = [[DADevice alloc] init];
    NSString *globallyUniqueString = dADevice.UID;
    XCTAssertNotNil(globallyUniqueString, @"FALHA - Não gerou globallyUniqueString!");
}
@end
