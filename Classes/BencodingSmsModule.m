/**
 * benCoding.SMS Project
 * Copyright (c) 2009-2012 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "BencodingSmsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation BencodingSmsModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
    bool marketPlace=YES;
    
    if(marketPlace)
    {
        return @"3da44764-ff07-4299-9a09-e3671743bfce";
    }
	else
    {
        return @"243a68e8-2097-4867-a435-a01ce546ed1f";
    }
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"bencoding.sms";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

@end
