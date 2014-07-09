//
//  SelfieTests.m
//  SelfieTests
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SelfieTests : XCTestCase

@end

@implementation SelfieTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)test {
//    return NO;
    XCTFail(@"failed@");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
