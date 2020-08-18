# CCAvenueIntegration-Swift
Swift 4.0
For Open SSL files create folder name SSL and include files noted below
1. module.modulemap
2. shim.h
3. libcrypto.a
4. libssl.a
5. include (Folder)
6. lib (Folder)
include and lib folders contains header files and library files respectively which requires for ssl encryption.
In TARGETS do this changes
1. Build Settings -> Swift Compiler - General -> Objective-C Bridging Header = $(SRCROOT)/ $(PROJECT_NAME)/CCIntegrationKit_swift+bridging.h
2. Build Settings -> Search Paths -> Always Search User Paths = YES
3. Build Settings -> Search Paths -> Header Search Paths = “$(SRCROOT)/$
(PROJECT_NAME)/include”, And Mark as Recursive.
4. Build Settings -> Search Paths -> Library Search Paths = “$(SRCROOT)/$
(PROJECT_NAME)/lib”, And Mark as Recursive.
5. Enable Bitcode = NO
6. Build Phases -> Link Binary With Libraries -> add libcrypto.a and libssl.a
Copy CCTool.h, CCTool.m, Base64.h, Base64.m, CCIntegrationKit_swift+bridging into your project.

# CONFIGURATION FOR MERCHANT DEMO

Merchant need to pass there
1. Merchant ID
2. AccessCode
3. OneCurrencyIDfortransaction(EgINR,AED,USD)
4. Transaction Amount which should be greater than zero, Cancel URL and redirect URL (URL At merchant wish to receive response for the transaction)
5. RSA Key URL (Where merchant will host there RSA Generator file)
6. lib (Folder)

If the existing merchant is trying this configuration then he can use intTrans URL as :
# “https:/ secure.ccavenue.com/transaction/initTrans”
else for the new merchant for the testing please change initTrans URL as :
# “https:/ test.ccavenue.com/transaction/initTrans”
Please find InitTrans URL in CCWebViewController.swift file
