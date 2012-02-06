
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

sms.addEventListener('cancelled', messageCancelled);
sms.addEventListener('completed', messageCompleted);
sms.addEventListener('errored', messageErrored);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var container = Ti.UI.createView({
	top:10,
	layout:'vertical'
});
win.add(container);

var supportedLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Feature supported: " + ((sms.canSendText)? "Yes" : "No"),
	left:10,
	height:40,
	width:'auto',
	textAlign:'left',
	font:{
		fontSize:20,
		fontWeight:'bold'
	}
});
container.add(supportedLabel);

var numberLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Enter a sample #:",
	top:20,
	left:10,
	height:40,
	width:'auto',
	textAlign:'left',
	font:{
		fontSize:16
	}
});
container.add(numberLabel);

var numbertText = Ti.UI.createTextField({
	value:'555-5555',
	height:35,
	top:2,
	left:10,
	keyboardType:Ti.UI.KEYBOARD_NUMBERS_PUNCTUATION,
	returnKeyType:Ti.UI.RETURNKEY_DONE,	
	borderStyle:Ti.UI.INPUT_BORDERSTYLE_ROUNDED
});

container.add(numbertText);

var msgLabel = Ti.UI.createLabel({
	color:'#000',
	text:"Enter a sample Message:",
	left:10,
	height:40,
	width:'auto',
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
	returnKeyType:Ti.UI.RETURNKEY_DONE,	
	borderStyle:Ti.UI.INPUT_BORDERSTYLE_ROUNDED
});

container.add(msgText);

var testButton = Ti.UI.createButton({
	title:'Open SMS Dialog',
	height:40,
	width:200,
	top:20
});

container.add(testButton);

testButton.addEventListener('click', function(){
	
	if(!sms.canSendText){
		var noSupport = Ti.UI.createAlertDialog({
				title:'Not Supported',
				message:"This device doesn't support sending text messages" 
			}).show();
						
		return;
	}
				
	sms.setMessageBody(msgText.value);
	sms.setToRecipients([numbertText.value]);
	sms.open({animated:true});
});
win.open();
