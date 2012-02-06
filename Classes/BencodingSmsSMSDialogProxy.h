/**
 * benCoding.SMS Project
 * Copyright (c) 2009-2012 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import <MessageUI/MFMessageComposeViewController.h>
#import "TiProxy.h"

@interface BencodingSmsSMSDialogProxy : TiProxy<MFMessageComposeViewControllerDelegate> {
    MFMessageComposeViewController *smsController;
    NSNumber *canSendText;
    BOOL showAnimated;
}

@property(readonly,nonatomic) NSNumber *canSendText;

@end
