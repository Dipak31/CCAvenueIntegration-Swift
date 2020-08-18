//
//  CCTool.h
//  CCIntegrationKit
//
//  Created by test on 5/14/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTool : NSObject
- (NSString *)encryptRSA:(NSString *)raw key:(NSString *)pubKey;
@end
