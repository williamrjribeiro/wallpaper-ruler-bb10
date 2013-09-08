import bb 1.0
import bb.cascades 1.0
import bb.system 1.0
import bb.platform 1.0

// It's better to work with JavaScript Object in separate js files. http://harmattan-dev.nokia.com/docs/library/html/qt4/qml-variant.html 
import "js/togglebuttonmanager.js" as ToggleButtonManager;

Page {
    id: mfeRootPage
    resizeBehavior: PageResizeBehavior.None
    
    signal finishedEditting()
    
    property alias imageEditor: ime_editor;
    //property alias imageSource: ime_editor.imageTrackerSource;
    property alias tutorial: cdl_tutorialFrame.sourceComponent;
    
    property string failureMessage: qsTr("Oops! Something went wrong. Please try again.");
    property string savedMessage: qsTr("Wappy image saved! Saving it for later?");
    property string wallpaperSetMessage: qsTr("Wappy wallpaper set! Great choice!");
    
    property ActionItem toggledActionItem: null; // keep track of which frame is currently shown (ActionItem.objectName)
    
    onCreationCompleted: {
        console.log("[MultipleFramesEditor.mfeRootPage.onCreationCompleted]");
        
        // show or not the Long Press tutorial image
        if(_appSettings.showTutorial){
            cdl_tutorialFrame.delegateActive = true;
        }
        
        // These objects are managed by the ToggleButtonManager. The assets must be specified.
        var buttons = [
          {
              'actionItem' : ai_homeFrame,
              'toggled' : false,
              'toggledAsset' : "icons/ic_home_screen_a.png",
              'untoggledAsset' : "icons/ic_home_screen.png"
          },
          {
              'actionItem' : ai_lockedFrame,
              'toggled' : false,
              'toggledAsset' : "icons/ic_locked_a.png",
              'untoggledAsset' : "icons/ic_locked.png"
          },
          {
              'actionItem' : ai_activeFrame,
              'toggled' : false,
              'toggledAsset' : "icons/ic_active_screen_a.png",
              'untoggledAsset' : "icons/ic_active_screen.png"
          }  
        ];
        
        ToggleButtonManager.initToggleButtons(buttons);
        
        // The invokedWith signal is emmited when the app is invoked with a QUrl to a file to be shown
        _wpr.invokedWith.connect(setImageSource);
    }
    
    /**
     * Toggles the display of the frame images. Max of one frame can be visible at any given time.
     * It activate the ControlDelegates when needed. <br />
     * @param show - opacity of frame is set to 1.0 if true, 0.0 otherwise <br />
     * @actionItem - The toggled action item that called this function. It's used to determine which frames show or hide. <br />
     */
    function showFrame(show, actionItem){
        console.log("[MultipleFramesEditor.showFrame] show:",show,", actionItem.objectName:",actionItem.objectName);
        switch(actionItem.objectName){
            case ai_homeFrame.objectName:
                if(cdl_homeFrame.delegateActive == false)
                    cdl_homeFrame.delegateActive = true;
                
                cdl_homeFrame.control.opacity = show ? 1.0 : 0.0;
                
                if(cdl_activeFrame.delegateActive)
                    cdl_activeFrame.control.opacity = 0.0;
                
                if(cdl_lockedFrame.delegateActive)
                    cdl_lockedFrame.control.opacity = 0.0;
                break;
            case ai_activeFrame.objectName:
                
                if(cdl_activeFrame.delegateActive == false)
                    cdl_activeFrame.delegateActive = true;
                
                cdl_activeFrame.control.opacity = show ? 1.0 : 0.0;
                
                if(cdl_homeFrame.delegateActive)
                    cdl_homeFrame.control.opacity = 0.0;
                
                if(cdl_lockedFrame.delegateActive)
                    cdl_lockedFrame.control.opacity = 0.0;
                
                break;
            case ai_lockedFrame.objectName:
                if(cdl_lockedFrame.delegateActive == false)
                    cdl_lockedFrame.delegateActive = true;
                
                cdl_lockedFrame.control.opacity = show ? 1.0 : 0.0;
                
                if(cdl_homeFrame.delegateActive)
                    cdl_homeFrame.control.opacity = 0.0;
                
                if(cdl_activeFrame.delegateActive)
                    cdl_activeFrame.control.opacity = 0.0;
                
                break;
        }
        
        toggledActionItem = show ? actionItem : null;
    }
    
    /**
     * Tries to set the given file image path as the device wallpaper. 
     * Show result message.
     * @param savedImage - path to an image file without protocol
     * @return result of HomeScreen.setWalllpaper() operation
     */
    function setAsDeviceWallpaper(savedImage){
        console.log("[MultipleFramesEditor.setAsDeviceWallpaper] savedImage: "+ savedImage +", locskState: "+hsc_deviceSreen.lockState);
        
        var result = hsc_deviceSreen.setWallpaper("file://" + savedImage); 
        if(  result == false ){
            console.log("[MultipleFramesEditor.setAsDeviceWallpaper] ERROR SETTING IMAGE AS DEVICE WALLPAPER!");
            showResultMessage(mfeRootPage.failureMessage);
            dismissCard("error", mfeRootPage.failureMessage);
        }
        else {
            showResultMessage(mfeRootPage.wallpaperSetMessage);
            dismissCard("set", mfeRootPage.wallpaperSetMessage);
        }
        return result;
    }
    
    /**
     * Uses the ImageProcessor to apply the user edits to the original image and save the result.
     * Show result message and if it's a successful operation, add the image to the app DataModel
     * @return path to the saved image file without protocol.
     */
    function saveImage(showNotification){
        console.log("[MultipleFramesEditor.saveImage] showNotification:",showNotification);
        
        var savedImage = _imageEditor.processImage( ime_editor.imageView.imageSource
            										,ime_editor.imageView.scaleX
            										,ime_editor.imageView.translationX
            										,ime_editor.imageView.translationY
            										,ime_editor.imageView.rotationZ
            										,_screenSize.width
                                                    ,_screenSize.height);
        if( savedImage == "" ){
            console.log("[MultipleFramesEditor.saveImage] ERROR SAVING IMAGE!");
            if(showNotification){
            	showResultMessage(mfeRootPage.failureMessage);
                dismissCard("error", mfeRootPage.failureMessage);
            }
        }
        else{
            
            if(showNotification){
            	showResultMessage(mfeRootPage.savedMessage);
                // Informe the Invocation Framework that the card is done ONLY if the user just saved the image
                dismissCard("saved", mfeRootPage.savedMessage);
            }
            
            // If the application is invoked as a Card, there's no data provider.
            if(typeof _imageGridDataProvider !== "undefined"){
            	_imageGridDataProvider.addImage(savedImage);
	        }
        }
        
        return savedImage;
    }
    
    function showResultMessage(msg){
        syt_resultMessage.body = msg;
        syt_resultMessage.show();
    }
    
    function dismissCard(reason, message){
        if(typeof _wpr !== "undefined")
            _wpr.cardDone(reason, message);
    }
    
    function releaseLowPriorityMemory(){
        // Untoggle the current toggled ActionItem (if a frame is currently shown)
        if(toggledActionItem != null){
            showFrame(ToggleButtonManager.handleToggle(toggledActionItem), toggledActionItem);
        }
        
        // unload every frame
        cdl_activeFrame.delegateActive = false;
        cdl_homeFrame.delegateActive = false;
        cdl_lockedFrame.delegateActive = false;
        cdl_tutorialFrame.delegateActive = false;
    }
    
    function setImageSource(filePath){
        // ignore the file:/// protocol
        var folders = filePath.substring(8).split('/'),
        	fileName = folders[folders.length - 1],
        	parentsName = "";
        
        // Start gathering the parent folders from the "shared" folder.
        for(var i = folders.indexOf("shared") + 1, l = folders.length - 1; i < l; i++){
        	parentsName += (folders[i] + "/"); 
        }
            
        console.log("[MultipleFramesEditor.setImageSource] parentsName:",parentsName,", fileName:",fileName,", filePath:",filePath);
            
        // Show the name of the selected file as the title of the context menu
        as_actions.title = fileName;
        
        // Show the folder structure of the selected file as the sub-title of the context menu
        as_actions.subtitle = parentsName;
        
        ime_editor.imageTrackerSource = filePath;
    }
    
    Container {
        id: mainContainer
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        implicitLayoutAnimationsEnabled: false
        background: Color.create("#ffe845bc")
        focusPolicy: FocusPolicy.KeyAndTouch
        layout: DockLayout { }
        
        ImageEditor {
            id: ime_editor
            implicitLayoutAnimationsEnabled: false
        }
        ControlDelegate {
            id: cdl_homeFrame
            delegateActive: false;
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive        
            sourceComponent: ComponentDefinition {
                id: cdf_homeImage
                ImageView {
                    id: iv_homeFrame
                    opacity: 0.0
                    scalingMethod: ScalingMethod.None
                    loadEffect: ImageViewLoadEffect.Subtle
                    imageSource: "images/fr_home.png"
                }
            }
        }
        ControlDelegate {
            id: cdl_activeFrame
            delegateActive: false;
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            sourceComponent: ComponentDefinition {
                id: cdf_activeImage
                ImageView {
                    id: iv_activeFrame
                    opacity: 0.0
                    scalingMethod: ScalingMethod.None
                    loadEffect: ImageViewLoadEffect.Subtle
                    imageSource: "images/fr_active.png"
                }
            }
        }
        ControlDelegate {
            id: cdl_lockedFrame
            delegateActive: false;
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            sourceComponent: ComponentDefinition {
                id: cdf_lockedImage
                ImageView {
                    id: iv_lockedFrame
                    opacity: 0.0
                    scalingMethod: ScalingMethod.None
                    loadEffect: ImageViewLoadEffect.Subtle
                    imageSource: "images/fr_locked.png"
                }
            }
        }
        ControlDelegate {
            id: cdl_tutorialFrame
            delegateActive: false;
            sourceComponent: ComponentDefinition {
                Container {
                    id: ctn_tutorial
                    preferredWidth: _screenSize.width
                    preferredHeight: _screenSize.height
                    background: Color.create("#aa000000")
                    layout: DockLayout {}
                    ImageView {
                        id: iv_tutorialFrame
                        imageSource: "images/long_press.png"
                        visible: true
                        opacity: 1.0
                        scalingMethod: ScalingMethod.None
                        loadEffect: ImageViewLoadEffect.DefaultDeferred
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                    Container {
                        rightPadding: 20.0
                        bottomPadding: 20.0
                        verticalAlignment: VerticalAlignment.Bottom
                        horizontalAlignment: HorizontalAlignment.Right
                        ImageView {
                            id: iv_tutorialClose
                            imageSource: "images/long_press_close.png"
                            scalingMethod: ScalingMethod.None
                            loadEffect: ImageViewLoadEffect.DefaultDeferred
                        }
                    }
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                //console.log("[MultipleFramesEditor.ctn_tutorial.onTapped]");
                                trans_fadeOut.play();
                            }
                        }
                    ]
                    animations: [
                        FadeTransition {
                            id: trans_fadeOut
                            fromOpacity: 1.0
                            toOpacity: 0.0
                            onEnded: {
                                console.log("[MultipleFramesEditor.ctn_tutorial.trans_fadeOut.onEnded]");
                                // the tutorial frame will remain invisible even after the user leaves the MFE.
                                visible = false;
                                
                                // Don't show the tutorial image anymore
                                _appSettings.showTutorial = false;
                                
                                // remove this instance
                                cdl_tutorialFrame.delegateActive = false;
                            }
                        }
                    ]
                }
            }
        }
        
        contextActions: [
            ActionSet {
                id: as_actions
                ActionItem {
                    id: ai_homeFrame
                    objectName: "homeFrameToggle"
                    title: qsTr("Home Screen")
                    imageSource: "icons/ic_home_screen.png"
                    onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_homeFrame), ai_homeFrame);
                    shortcuts: [ Shortcut { key: "h" } ]
                }
                ActionItem {
                    id: ai_lockedFrame
                    objectName: "lockedFrameToggle"
                    title: qsTr("Locked Screen")
                    imageSource: "icons/ic_locked.png"
                    onTriggered:  showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame), ai_lockedFrame);
                    shortcuts: [ Shortcut { key: "l" } ]
                }
                ActionItem {
                    id: ai_activeFrame
                    objectName: "activeFrameToggle"
                    title: qsTr("Active Frames")
                    imageSource: "icons/ic_active_screen.png"
                    onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_activeFrame), ai_activeFrame)
                    shortcuts: [ Shortcut { key: "a" } ]
                }
                ActionItem {
                    id: ai_setAsWallpaper
                    title: qsTr("Set as Wallpaper!")
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "icons/ic_saveaswallpaper.png"
                    onTriggered: setAsDeviceWallpaper( saveImage(false) )
                    shortcuts: [ Shortcut { key: "w" } ]
                }
				ActionItem {
				    id: ai_saveImage
				    title: qsTr("Save")
				    ActionBar.placement: ActionBarPlacement.InOverflow
				    imageSource: "icons/ic_save.png"
				    onTriggered: saveImage(true)
                    shortcuts: [ Shortcut { key: "s" } ]
				}
                ActionItem {
                    id: ai_cancel
                    title: qsTr("Back to gallery")
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "icons/ic_gallery_back.png"
                    // When this action is selected, close the sheet
                    onTriggered: syd_cancelWarning.show()
                    shortcuts: [ Shortcut { key: "b" } ]
                    
                }
            } // end of ActionSet
        ]// end of contextActions list
        
        contextMenuHandler: ContextMenuHandler {
            id: cmh_handler
            // Abort the showing of the context menu if the user is interacting with the Image
            onPopulating: if (ime_editor.imageView.pinchHappening) event.abort(); else event;
            onVisualStateChanged: {
                // Don't allow dragging or pinching if Context Menu is shown
                if (ContextMenuVisualState.VisibleCompact == cmh_handler.visualState) {
                    ime_editor.imageView.pinchHappening = true;
                }
                else if (ContextMenuVisualState.Hidden == cmh_handler.visualState) {
                    ime_editor.imageView.pinchHappening = false;
                }
            }
        }
        
        attachedObjects: [
            SystemDialog {
                id: syd_cancelWarning
                title: qsTr("Back to gallery")
                body: qsTr("Any changes made after last save will be lost. Continue?")
                onFinished: {
                    if (syd_cancelWarning.result == SystemUiResult.ConfirmButtonSelection) {
                        finishedEditting();
                        dismissCard("cancel","");
                    }
                }
            },
            HomeScreen {
                id: hsc_deviceSreen
                onWallpaperFinished: {
                    console.log("[MultipleFramesEditor.hsc_deviceSreen.onWallpaperFinished] result: "+result+", path: "+path);
                }
            },
            SystemToast {
                id: syt_resultMessage
            },
            MemoryInfo {
                id: memoryInfo
                onLowMemory: {
                    console.log("[MultipleFramesEditor.memoryInfo.onLowMemory] level:",level);
                    if (level == LowMemoryWarningLevel.LowPriority) {
                        releaseLowPriorityMemory();
                    }
                }
            }
        ]

    } // mainContainer end
    
    shortcuts: [
        Shortcut {
            key: "b"
            onTriggered: syd_cancelWarning.show();
        },
        Shortcut {
            key: "a"
            onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),ai_activeFrame);
        },
        Shortcut {
            key: "l"
            onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),ai_lockedFrame);
        },
        Shortcut {
            key: "h"
            onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),ai_homeFrame);
        },
        Shortcut {
            key: "s"
            onTriggered: saveImage(true)
        },
        Shortcut {
            key: "w"
            onTriggered: setAsDeviceWallpaper( saveImage(false) )
        }
    ]
}
