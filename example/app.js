
var sms = require('bencoding.sms').createSMSDialog({ barColor:'#336699' });
Ti.API.info("module is => " + sms);

Ti.API.info("Is This Feature Supported? => " + sms.canSendText);

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

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var hintLabel = Ti.UI.createLabel({
	color:'#000',
	text:"This is a sample app for the benCoding.SMS module. Please review the documentation on how to use this module.",
	left:10,
	right:10,
	height:60,
	top:5,
	textAlign:'left',
	font:{
		fontSize:14
	}
});
win.add(hintLabel);

var container = Ti.UI.createView({
	top:70,
	layout:'vertical'
});
win.add(container);

var supportedLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Feature supported: " + ((sms.canSendText)? "Yes" : "No"),
	left:10,
	right:10,
	height:30,
	textAlign:'left',
	font:{
		fontSize:16,
		fontWeight:'bold'
	}
});
container.add(supportedLabel);

var hint2Label = Ti.UI.createLabel({
	color:'#000',
	text:"You can tell if the feature is supported by checking the canSendText property",
	left:10,
	right:10,
	height:40,
	textAlign:'left',
	font:{
		fontSize:14
	}
});
container.add(hint2Label);

var numberLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Enter a sample #:",
	top:10,
	left:10,
	right:10,
	height:40,
	textAlign:'left',
	font:{
		fontSize:16
	}
});
container.add(numberLabel);

var numbertText = Ti.UI.createTextField({
	value:'555-555-1234',
	height:35,
	top:2,
	left:10,
	right:10,
	keyboardType:Ti.UI.KEYBOARD_NUMBERS_PUNCTUATION,
	returnKeyType:Ti.UI.RETURNKEY_DONE,	
	borderStyle:Ti.UI.INPUT_BORDERSTYLE_ROUNDED
});

container.add(numbertText);

var msgLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Enter a sample Message:",
	left:10,
	right:10,
	height:40,
	textAlign:'left',
	font:{
		fontSize:16
	}
});
container.add(msgLabel);

var msgText = Ti.UI.createTextField({
	value:'Appcelerator Titanium Rocks!',
	height:50,
	top:2,
	left:10,
	right:10,	
	returnKeyType:Ti.UI.RETURNKEY_DONE,	
	borderStyle:Ti.UI.INPUT_BORDERSTYLE_ROUNDED
});

container.add(msgText);

var hint3Label = Ti.UI.createLabel({
	color:'#000',
	text:"Press the button to open a dialog showing the number & message entered",
	left:10,
	right:10,
	top:10,
	height:40,
	textAlign:'left',
	font:{
		fontSize:14
	}
});
container.add(hint3Label);

var testButton = Ti.UI.createButton({
	title:'Open SMS Dialog',
	height:40,
	width:200,
	top:20
});

container.add(testButton);

testButton.addEventListener('click', function(){
	
	//This is an example of how to check if the device can send Text Messages
	if(!sms.canSendText){
		var noSupport = Ti.UI.createAlertDialog({
				title:'Not Supported',
				message:"This device doesn't support sending text messages" 
			}).show();
						
		return;
	}

	//Set the SMS message, you can also do this when you create the SMSDialog				
	sms.setMessageBody(msgText.value);
	
	//Set the SMS ToRecipients, you can also do this when you create the SMSDialog
	//This is an array so you can pass in several numbers for the message to be sent to	
	sms.setToRecipients([numbertText.value]);
	
	//This call opens the SMS Message Dialog window withe number and message you provided earlier
	sms.open({
			animated:true //Indicate if the dialog should be animated on open (OPTIONAL)
			//portraitOnly:true //Indicate if we lock the dialog into the portrait orientation only (OPTIONAL)	
	});
});
win.open();