/**
 * benCoding.SMS Project
 * Copyright (c) 2012-2014 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import <MessageUI/MFMessageComposeViewController.h>
#import "TiProxy.h"
@interface MFMessageComposeViewController (AutoRotation)
// to stop auto rotation
@end
@interface BencodingSmsSMSDialogProxy : TiProxy<MFMessageComposeViewControllerDelegate> {
    NSNumber *__weak canSendText;
    BOOL showAnimated;
}

@property(weak, readonly,nonatomic) NSNumber *canSendText;

@end
