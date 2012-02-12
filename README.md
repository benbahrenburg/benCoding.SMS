<h1>benCoding.SMS Module</h1>

The benCoding.SMS module makes it easy to add SMS functionality into your iOS Titanium apps. We unleash the power of Apple's native Apple SMS component [MFMessageComposeViewController](https://developer.apple.com/library/ios/#documentation/MessageUI/Reference/MFMessageComposeViewController_class/Reference/Reference.html) to Titanium with an API fashioned after the Titanium EmailDialog to make it familiar to use.

<h2>Before you start</h2>
* This is an iOS module designed to work with Titanium SDK 1.8.1 or greater.
* Before using this module you first need to install the package. If you need instructions on how to install a 3rd party module please read this installation guide.
* If you would like access to the source code, please visit us on Github at [https://github.com/benbahrenburg/benCoding.SMS](https://github.com/benbahrenburg/benCoding.SMS).
<h2>Setup</h2>

* Download the latest release from the releases folder ( or you can build it yourself )
* Install the bencoding.sms module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<pre><code>

var sms = require('bencoding.sms').createSMSDialog();

</code></pre>

Now we have the module installed and avoid in our project we can start to use the components, see the feature guide below for details.

<h2>benCoding.SMS How To Example</h2>

For detailed documentation please reference this project's documentation folder.
A code "How To" example is provided in the app.js located in the project's example folder.

<h2>Properties</h2>
<hr />

This module provides access to most of the native MFMessageComposeViewController's functionality.

<h3>canSendText</h3>
Returns a boolean whether the device has the ability to send Text Messages.  Please keep in mind this value will always be false when running on the simulator. (Read Only)

<h3>messageBody</h3>
The SMS message

<h3>toRecipients</h3>
An array of SMS recipients ie phone numbers

<h3>barColor</h3>
The bar color of the email dialog window when opened

Below is a description and example on how to use each supported method.

<pre><code>

var sms = require('bencoding.SMS').createSMSDialog({
            barColor:'#336699', //set the SMS Dialog barColor
            messageBody:"Appcelerator Titanium Rocks!", //Set SMS Message
            toRecipients:[{"555-555-5555"},{"444-444-4444"}] //Who we are the SMS sending to
});

</code></pre>

<h3>canSendText</h3>
This property returns a boolean indicator on whether or not sending SMS Messages is supported.

The below sample shows how you can check if this feature is supported.
<pre><code>

Ti.API.info("Can I send messages?");
Ti.API.info("Is This Feature Supported? => " + sms.canSendText); 

//This is an example of how to check if the device can send Text Messages 
if(!sms.canSendText){ 
        var noSupport = Ti.UI.createAlertDialog({ 
           title:'Not Supported', 
           message:"This device doesn't support sending text messages" }).show(); 
      return; 
}

</code></pre>

<h2>Methods</h2>
<hr />

<h3>setBarColor</h3>
Sets the barColor property for the SMS Dialog, see below for an example on how to use this.

<h3>setToRecipients</h3>
Sets the toRecipients property with an array ( ie an array of phone numbers),see below for an example on how to use this.

<h3>setMessageBody</h3>
Sets the messageBody property with a string. This is used to set the message shown in the SMSDialog,see below for an example on how to use this.

<h3>open</h3>
This opens the SMS dialog. The SMS dialog itself is a modal window.

<h3>Method Usage Example</h3>
The below example shows how to use all of the methods. For additional samples please see the example folder contained within the module or [here on Github](https://github.com/benbahrenburg/benCoding.SMS/tree/master/example).

<pre><code>
//Set the SMS BarColor
sms.setBarColor('#336699');

//Set the SMS message, you can also do this when you create the SMSDialog
sms.setMessageBody("Appcelerator Titanium Rocks!");

//Set the SMS ToRecipients, you can also do this when you create the SMSDialog
//This is an array so you can pass in several numbers for the message to be sent to
sms.setToRecipients([{"555-555-5555"},{"444-444-4444"}]);

//This call opens the SMS Message Dialog window withe number and message you provided earlier
sms.open({ 
    animated:true //Indicate if the dialog should be animated on open (OPTIONAL) 
}); 	
</code></pre>

<h2>Events</h2>
<hr />
<h3>completed</h3>
This event is fired when the user presses the cancel button on the SMS Dialog

<h3>cancelled</h3>
This event is fired when an SMS message is sent successfully

<h3>errored</h3>
This event is fired when an error happens sending a message	

<h3>Event Usage Example</h3>
The below example shows how to use all of the events. Please note the events will not become active until the open method is called.

For additional samples please see the example folder contained within the module or [here on Github](https://github.com/benbahrenburg/benCoding.SMS/tree/master/example).
<pre><code>
var sms = require('bencoding.sms').createSMSDialog({ barColor:'#336699' });

//If you want you can define some callbacks
function messageCompleted(e){
    alert(e.message); 
};
function messageErrored(e){
    alert(e.message); 
};

function messageCancelled(e){
    alert(e.message); 
};

//Add the listeners so we know when an action happens
sms.addEventListener('cancelled', messageCancelled);
sms.addEventListener('completed', messageCompleted);
sms.addEventListener('errored', messageErrored);
</code></pre>
<hr />

<h2>FAQ</h2>

<h3>Can I automately send the SMS message without showing it to the user?</h3>
No, this is not supported by Apple.

<h3>Can I send a MMS?</h3>
No, the current Apple API does not allow for this.

<h3>Can I change the style of the dialog?</h3>
You can update the barColor by setting the barColor property when creating the SMSDialog or by calling the setBarColor method before calling the open method.

<h3>Is there an Android version?</h3>
You can do this using activities on Android without the need of a module.  This module is an iOS only wrapper around the native [MFMessageComposeViewController](https://developer.apple.com/library/ios/#documentation/MessageUI/Reference/MFMessageComposeViewController_class/Reference/Reference.html) component. 

<hr />

<h2>Licensing & Support</h2>

This project is licensed under the OSI approved Apache Public License (version 2). For details please see the license associated with each project.

Developed by [Ben Bahrenburg](http://bahrenburgs.com) available on twitter [@benCoding](http://twitter.com/benCoding)

<h2>Learn More</h2>
<hr />
<h3>Twitter</h3>

Please consider following the [@benCoding Twitter](http://www.twitter.com/benCoding) for updates 
and more about Titanium.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [benCoding.Com](http://benCoding.com). 
