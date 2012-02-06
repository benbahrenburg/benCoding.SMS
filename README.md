<h1>benCoding.SMS Module</h1>

Add SMS capabilities into your Titanium app.  This module provides Titanium access to the native Apple SMS component [MFMessageComposeViewController](https://developer.apple.com/library/ios/#documentation/MessageUI/Reference/MFMessageComposeViewController_class/Reference/Reference.html).

<h2>Before you start</h2>
* You need Titanium 1.8.1 or greater.
* This module will only work with iOS 4 or great.  

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

Below is a description and example on how to use each supported method.
<h3>canSendText</h3>
This property returns a boolean indicator on whether or not sending SMS Messages is supported.

The below sample shows how you can check if this feature is supported.
<pre><code>

Ti.API.info("Check if we can send messages");
var featureSupported = sms.canSendText();
Ti.API.info("Is Supported? => " + featureSupported);

</code></pre>

<h2>Methods</h2>
<hr />
<h3>open</h3>
	
	Coming soon....
	
</code></pre>

<h2>Events</h2>
<h3>completed</h3>
	
	Coming soon...
<h3>cancelled</h3>
	
	Coming soon...
<h3>errored</h3>
	
	Coming soon...		
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
