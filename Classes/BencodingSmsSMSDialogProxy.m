/**
 * benCoding.SMS Project
 * Copyright (c) 2009-2012 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingSmsSMSDialogProxy.h"
#import "TiUtils.h"
#import "TiApp.h"
@implementation BencodingSmsSMSDialogProxy

@synthesize canSendText;
-(id)init
{
    showAnimated=YES;
    //Set a property so that we know if we can send a text message
    canSendText=NUMBOOL([MFMessageComposeViewController canSendText]);
    
	// This is the designated initializer method and will always be called when the proxy is created.
    return [super init];    
}


-(void)open:(id)args
{    
    //Set default in case nothing is provided
    int style=-1; 
    showAnimated=YES;
    
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
        style = [TiUtils intValue:@"modalTransitionStyle" properties:args def:-1];   
    }
    
	Class arrayClass = [NSArray class];
	NSArray * toArray = [self valueForUndefinedKey:@"toRecipients"];
    ENSURE_CLASS_OR_NIL(toArray,arrayClass);
    
    //Make sure we're on the UI thread, this stops bad things
	ENSURE_UI_THREAD(open,args);
    
    //Grab the message
    NSString * message = [TiUtils stringValue:[self valueForUndefinedKey:@"messageBody"]];
    
    smsController = [[[MFMessageComposeViewController alloc] init] autorelease];
    
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
    //If no style provided, we skip this
    if (style!=-1)
    {    
        //We apply the style        
        [smsController setModalTransitionStyle:style];        
    }     
    
    //We call into core TiApp module this handles the controller magic for us        
    [[TiApp app] showModalController:smsController animated:showAnimated];        
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *eventName;
    NSString *msg;
    if(smsController !=nil)
    {
        [[TiApp app] hideModalController:smsController animated:showAnimated];  
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
    
}


-(void)_destroy
{
	// This method is called from the dealloc method and is good place to
	// release any objects and memory that have been allocated for the proxy.	
    if(smsController !=nil)
    {
        RELEASE_TO_NIL(smsController);     
    }        
    RELEASE_TO_NIL(canSendText);
    [super _destroy];
}

@end
