/**
 * benCoding.SMS Project
 * Copyright (c) 2012-2014 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingSmsSMSDialogProxy.h"
#import "TiUtils.h"
#import "TiApp.h"

BOOL lockPortrait = NO;
BOOL statusBarHiddenCheck = NO;
BOOL statusBarHiddenOldValue = NO;

@implementation MFMessageComposeViewController (AutoRotation)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(lockPortrait==YES)
    {
        return NO;
    }
    else
    {
        //Check if the orientation is supported in the Tiapp.xml settings
        BOOL allowRotate = [[[TiApp app] controller] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
        //If it is supported, we need to move the entire app. 
        //Without doing this, our keyboard wont reposition itself
        if(allowRotate==YES)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
        }
        //We tell the app if we can rotate, ie is this a support orientation
        return allowRotate;        
    }
}

@end

@implementation BencodingSmsSMSDialogProxy

@synthesize canSendText;
-(id)init
{
    if (self = [super init])
    {
        showAnimated=YES;
        BOOL deviceCanSend = YES;
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass == nil)
        {
            deviceCanSend=NO;
        }else
        {
            //Check if we have support
            if([MFMessageComposeViewController canSendText]==NO)
            {
                deviceCanSend=NO;
            }        
        }        
        //Set a property so that we know if we can send a text message
        canSendText=NUMBOOL(deviceCanSend);
    
    }
    
    return self;  
}

-(void) resetFlags
{
    lockPortrait = NO;
    statusBarHiddenCheck = NO;
    statusBarHiddenOldValue = NO;
}
-(void)forceDispose:(id)unused
{
    RELEASE_TO_NIL(canSendText);
    RELEASE_TO_NIL(smsController);
}

-(void)_destroy
{
    [self forceDispose:nil];
    [super _destroy];
}

- (void) dealloc
{
	[self forceDispose:nil];
	[super dealloc];
}


-(void)open:(id)args
{
    showAnimated=YES; //Force reset in case dev wants to toggle
    BOOL deviceCanSend = YES;
    
    //Remember JS object to avoid GC
    [self rememberSelf];
    //Reset our flags in case we are calling many times with different values
    [self resetFlags];
    
    //Check the message class exists
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass == nil)
    {
        deviceCanSend=NO;
    }else
    {
        //Check if we have support
        if([MFMessageComposeViewController canSendText]==NO)
        {
            deviceCanSend=NO;
        }        
    }

    if(deviceCanSend==NO)
    {
        if ([self _hasListeners:@"errored"]) {
            NSDictionary *errorEvent = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Your device does not support sending text messages",@"message",
                                        nil
                                        ];
            
            [self fireEvent:@"errored" withObject:errorEvent];
        }         
        return;
    }
    
	//We need to do a few checks here to figure out what to do
    //This check is due to some side effects
    if((args ==nil)||([args count] == 0))
    {
        //If no arguments are passed we need to take a different action
        ENSURE_TYPE_OR_NIL(args,NSDictionary);
    }
    else        
    {
        //If there are agruments we need to do this
        //Get the user's animated option if provided
        ENSURE_SINGLE_ARG(args,NSDictionary);
        showAnimated = [TiUtils boolValue:@"animated" properties:args def:YES];
        lockPortrait= [TiUtils boolValue:@"portraitOnly" properties:args def:NO];
    }
    
	Class arrayClass = [NSArray class];
	NSArray * toArray = [self valueForUndefinedKey:@"toRecipients"];
    ENSURE_CLASS_OR_NIL(toArray,arrayClass);
    
    //Make sure we're on the UI thread, this stops bad things
	ENSURE_UI_THREAD(open,args);
    
    //Grab the message
    NSString * message = [TiUtils stringValue:[self valueForUndefinedKey:@"messageBody"]];
    
    smsController = [[MFMessageComposeViewController alloc] init];

    //Check if we need to hide the statusbar
    BOOL statusBarHidden = [TiUtils boolValue:[self valueForUndefinedKey:@"statusBarHidden"] def:NO];
    
    //If we are hiding the statusbar we perform the below
    if(statusBarHidden==YES)
    {
        //Set our dialog to full screen 
        smsController.wantsFullScreenLayout = NO;  
        //Get the existing statusbar value so we can reset it later on
        statusBarHiddenOldValue = [UIApplication sharedApplication].statusBarHidden;
        //Set our status flag
        statusBarHiddenCheck =  YES;
    }

    //See if we need to do anything with the barColor
    UIColor * barColor = [[TiUtils colorValue:[self valueForUndefinedKey:@"barColor"]] _color];
    if (barColor != nil)
    {
        [[smsController navigationBar] setTintColor:barColor]; 
    }

    //Build the message contents
    smsController.body = message;        
    smsController.recipients = toArray;    
    smsController.messageComposeDelegate = self;
    
    //If we are hiding the statusbar we need to do it after it is presented
    if(statusBarHidden==YES)
    {
        //We need to hide the statusbar for the full app
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //[[[TiApp app] controller] resizeViewForStatusBarHidden:YES];
    }
    
    [self retain];
    
    //We call into core TiApp module this handles the controller magic for us        
    [[TiApp app] showModalController:smsController animated:showAnimated]; 
    
    
}

#pragma mark Delegate 
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *eventName;
    NSString *msg;
    
    if (result == MessageComposeResultCancelled)
    {
        eventName=@"cancelled";
        msg=@"Message was cancelled";
        
    }
    else if (result == MessageComposeResultSent)
    {
        eventName=@"completed";  
        msg=@"Message sent successfully";
    }
    else
    {
        eventName=@"errored";
        msg=@"Error sending message";
    }
    
 
    //If we enabled full screen, we need to set it back 
    if(statusBarHiddenCheck==YES)
    {
        statusBarHiddenCheck=NO; //Reset our flag here
        //We set the statusbar value to what it was before we started
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHiddenOldValue];  
        //[[[TiApp app] controller] resizeViewForStatusBarHidden:statusBarHiddenOldValue];
    }
 
    BOOL animated = YES;
    [[TiApp app] hideModalController:smsController animated:animated];
    [smsController autorelease];
    smsController = nil;
    
    if ([self _hasListeners:eventName]) {
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               msg,@"message",
                               nil
                               ];
        
        [self fireEvent:eventName withObject:event];      
    }  
    
    [self forgetSelf];
    [self autorelease];  
}

@end

