//
//  MDLAppDelegate.m
//  MendeleySDKDemoOSX
//
//  Created by Damien Mathieu on 29/07/2013.
//  Copyright (c) 2013 shazino. All rights reserved.
//

#import "MDLAppDelegate.h"
#import <MendeleySDK.h>

NSString * const MDLClientID       = @"##client_id##";
NSString * const MDLSecret         = @"##secret##";
NSString * const MDLURLScheme      = @"mdl-mendeleysdkdemo";

@implementation MDLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [MDLMendeleyAPIClient configureSharedClientWithClientID:MDLClientID
                                                     secret:MDLSecret
                                                redirectURI:MDLURLScheme];
}

@end
