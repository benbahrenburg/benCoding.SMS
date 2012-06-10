/**
 * benCoding.SMS Project
 * Copyright (c) 2009-2012 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingSmsSMSDialogProxy.h"
#import "TiUtils.h"
#import "TiApp.h"

BOOL lockPortrait = NO;

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
        //Set a property so that we know if we can send a text message
        canSendText=NUMBOOL([MFMessageComposeViewController canSendText]);
    
    }
    
    return self;  
}


-(void)open:(id)args
{    
    showAnimated=YES; //Force reset in case dev wants to toggle
    
    if([MFMessageComposeViewController canSendText]==NO)
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
    
    [self retain];
    
    //We call into core TiApp module this handles the controller magic for us        
    [[TiApp app] showModalController:smsController animated:showAnimated];        
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *eventName;
    NSString *msg;
    BOOL animated = YES;
        
    if(smsController !=nil)
    {
        [[TiApp app] hideModalController:smsController animated:animated];  
        [smsController autorelease];
        smsController = nil;        
    }
    
    if (result == MessageComposeResultCancelled){
        eventName=@"cancelled";
        msg=@"Message was cancelled";
        
    }else if (result == MessageComposeResultSent){
        eventName=@"completed";  
        msg=@"Message sent successfully";
    }else{
        eventName=@"errored";
        msg=@"Error sending message";
    }
    
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


-(void)_destroy
{       
    RELEASE_TO_NIL(canSendText);
    [super _destroy];
}

@end
