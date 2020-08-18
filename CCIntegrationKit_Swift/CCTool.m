//
//  CCTool.m
//  CCIntegrationKit
//
//  Created by test on 5/14/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

//
//  CCTool.m
//  seamless
//
//  Created by test on 5/14/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import "CCTool.h"
#include "Base64.h"

#import <openssl/pem.h>
#import <openssl/rsa.h>
@implementation CCTool

- (NSString *)encryptRSA:(NSString *)raw key:(NSString *)pubKey {
    const char *p = (char *)[pubKey UTF8String];
    
    BIO *bufio;
    NSUInteger byteCount = [pubKey lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    bufio = BIO_new_mem_buf((void*)p, byteCount);
    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bufio, 0, 0, 0);
    
    size_t plainTextLen = [raw lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned char plainText[plainTextLen+1];
    NSLog(@"plainText :: %s",plainText);
    
    size_t cipherTextLen = RSA_size(rsa);
    unsigned char cipherText[cipherTextLen + 1];
    [raw getCString:(char *)plainText maxLength:plainTextLen+1 encoding:NSUTF8StringEncoding];
    
    RSA_public_encrypt(plainTextLen, plainText, cipherText, rsa, RSA_PKCS1_PADDING);
    
    NSData *encrypted = [NSData dataWithBytes:cipherText length:cipherTextLen];
    NSLog(@"\n\n\nencrypted :: %@",encrypted);
    return [encrypted base64EncodedString];
}

@end
