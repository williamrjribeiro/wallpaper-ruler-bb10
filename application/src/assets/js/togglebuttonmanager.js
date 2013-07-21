/**
	An object where key is the ActionItem.objectName and the value is another Object with properties toggle and actionItem instance.
	E.g.:
	
	toggleMap = {
		'objectName1' : {
			'toggled' : false,
			'actionItem': ActionItem
		}
}
*/
var toggleMap = {};

/**
 * It changes the toggled state, and imageSource of all the ToggleButtons.
 * Only one toggle button can be toggled at a time.
 * @param toggleButton the ActionItem that was triggered.
 * @return the new toggled state of the given toggleButton. true or false.
 */
function handleToggle(toggleButton){
	console.log("[togglebuttonmanager.handleToggle] objectName: " + toggleButton.objectName);
    
	// the new toggled state of the given button.
	var toggled = false;
	
	// check every ToggleButton on the toggleMap
    for(var buttonName in toggleMap){
    	var item = toggleMap[buttonName]; 
    	
    	//console.log("[togglebuttonmanager.handleToggle] item.toggled: " + item.toggled + ", item.objectName: " + item.actionItem.objectName);
    	
    	if(buttonName == toggleButton.objectName){
    		if(item.toggled){
    			item.toggled = false;
    			item.actionItem.imageSource = "asset:///icons/ic_checkbox.png";
    	    }
    	    else{
    	    	item.toggled = true;
    	    	item.actionItem.imageSource = "asset:///icons/ic_checkbox_selected.png";
    	    }
    		
    		toggled = item.toggled;
    	}
    	else{
    		item.toggled = false;
    		item.actionItem.imageSource = "asset:///icons/ic_checkbox.png";
    	}
    }
    
    console.log("[togglebuttonmanager.handleToggle] toggled: " + toggled);
    return toggled;
}

/**
 * Creates the toggleMap object with the given ActionItems.
 * @param buttons array of ActionItem instances
 */
function initToggleButtons(buttons) {
	console.log("[togglebuttonmanager.initToggleButtons] buttons.length: " + buttons.length);
	for(var name in buttons){
		toggleMap[ buttons[name].objectName ] = {
				toggled: false,
				actionItem: buttons[name]
		};
	}
	
	console.log("[togglebuttonmanager.initToggleButtons] toggleMap: " + Object.getOwnPropertyNames(toggleMap));
}