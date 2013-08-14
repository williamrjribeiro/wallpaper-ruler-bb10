import bb.cascades 1.0
import bb.system 1.0
import bb.platform 1.0

// It's better to work with JavaScript Object in separate js files. http://harmattan-dev.nokia.com/docs/library/html/qt4/qml-variant.html 
import "js/togglebuttonmanager.js" as ToggleButtonManager;

Page {
    id: mfeRootPage
    resizeBehavior: PageResizeBehavior.None
    signal finishedEditting()
    property alias imageEditor: imageEditor
    property alias tutorial: controlDelegate.sourceComponent
    onCreationCompleted: {
        console.log("[MultipleFramesEditor.mfeRootPage.onCreationCompleted]");
        
        // show or not the Long Press tutorial image
        if(_appSettings.showTutorial){
            controlDelegate.delegateActive = true;
        }
        
        // These objects are managed by the ToggleButtonManager. The assets must be specified.
        var buttons = [
          {
              'actionItem' : ai_homeFrame,
              'toggled' : false,
              'toggledAsset' : "asset:///icons/ic_home_screen_a.png",
              'untoggledAsset' : "asset:///icons/ic_home_screen.png"
          },
          {
              'actionItem' : ai_lockedFrame,
              'toggled' : false,
              'toggledAsset' : "asset:///icons/ic_locked.png",
              'untoggledAsset' : "asset:///icons/ic_unlocked.png"
          },
          {
              'actionItem' : ai_activeFrame,
              'toggled' : false,
              'toggledAsset' : "asset:///icons/ic_active_screen_a.png",
              'untoggledAsset' : "asset:///icons/ic_active_screen.png"
          }  
        ];
        
        ToggleButtonManager.initToggleButtons(buttons);
    }
    function showFrame(show,filePath){
        console.log("[CustomCamera.showFrame] show: "+show+", filePath: "+filePath);
        switch(filePath){
            case "asset:///frames/fr_home.png":
                iv_homeFrame.opacity = show ? 1.0 : 0.0;
                iv_activeFrame.opacity = 0.0;
                iv_lockedFrame.opacity = 0.0;
                break;
            case "asset:///frames/fr_active.png":
                iv_homeFrame.opacity = 0.0;
                iv_activeFrame.opacity = show ? 1.0 : 0.0;
                iv_lockedFrame.opacity = 0.0;
                break;
            case "asset:///frames/fr_locked.png":
                iv_homeFrame.opacity = 0.0;
                iv_activeFrame.opacity = 0.0;
                iv_lockedFrame.opacity = show ? 1.0 : 0.0;
                break;
        }
    }
    function setAsDeviceWallpaper(savedImage){
        var result = myHomeScreen.setWallpaper("file://" + savedImage); 
        if(  result == false ){
            console.log("[MultipleFramesEditor.setAsDeviceWallpaper] ERROR SETTING IMAGE AS DEVICE WALLPAPER!");
        }
        else {
            _imageGridDataProvider.addImage(savedImage);
        }
        return result;
    }
    function saveImage(){
        //var savedImage = _imageEditor.processImage(imageEditor.myImageElement.imageSource, imageEditor.myImageElement.scaleX, imageEditor.myImageElement.translationX, imageEditor.myImageElement.translationY,imageEditor.myImageElement.rotationZ);
        var savedImage = _imageEditor.processImage( imageEditor.myImageElement.imageSource
            										,imageEditor.myImageElement.scaleX
            										,imageEditor.myImageElement.translationX
            										,imageEditor.myImageElement.translationY
            										,imageEditor.myImageElement.rotationZ
            										,_screenSize.width
                                                    ,_screenSize.height);
        if (savedImage == ""){
            console.log("[MultipleFramesEditor.saveImage] ERROR SAVING IMAGE!");
        }
        return savedImage;
    }
    Container {
        id: mainContainer
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        implicitLayoutAnimationsEnabled: false
        background: Color.Yellow
        focusPolicy: FocusPolicy.KeyAndTouch
        
        ImageEditor {
            id: imageEditor
            implicitLayoutAnimationsEnabled: false
        }
        
        ImageView {
            id: iv_homeFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_home.png"
        }
        
        ImageView {
            id: iv_activeFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_active.png"
        }
        
        ImageView {
            id: iv_lockedFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_locked.png"
        }
        
        ControlDelegate {
            id: controlDelegate
            delegateActive: false;
            sourceComponent: cd_tutorialImage
        }
        
        contextActions: [
            ActionSet {
                title: qsTr("Frames")
                subtitle: qsTr("The frames help you fit your images")
                ActionItem {
                    id: ai_homeFrame
                    objectName: "homeFrameToggle"
                    title: qsTr("Home Screen")
                    imageSource: "asset:///icons/ic_home_screen.png"
                    onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),"asset:///frames/fr_home.png");
                    shortcuts: [
                        Shortcut {
                            key: "h"
                        }
                    ]
                }
                ActionItem {
                    id: ai_lockedFrame
                    objectName: "lockedFrameToggle"
                    title: qsTr("Locked Screen")
                    imageSource: "asset:///icons/ic_locked.png"
                    onTriggered:  showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_locked.png");
                    shortcuts: [
                        Shortcut {
                            key: "l"
                        }
                    ]
                }
                ActionItem {
                    id: ai_activeFrame
                    objectName: "activeFrameToggle"
                    title: qsTr("Active Frame")
                    imageSource: "asset:///icons/ic_active_screen.png"
                    onTriggered: showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),"asset:///frames/fr_active.png")
                    shortcuts: [
                        Shortcut {
                            key: "a"
                        }
                    ]
                }
                ActionItem {
                    id: ai_setAsWallpaper
                    title: qsTr("Set as Wallpaper!")
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "asset:///icons/ic_save_as.png"
                    onTriggered: setAsDeviceWallpaper( saveImage() )
                    shortcuts: [
                        Shortcut {
                            key: "w"
                        }
                    ]
                }
				ActionItem {
				    id: ai_saveImage
				    title: qsTr("Save")
				    ActionBar.placement: ActionBarPlacement.InOverflow
				    imageSource: "asset:///icons/ic_save.png"
				    onTriggered: saveImage()
                    shortcuts: [
                        Shortcut {
                            key: "s"
                        }
                    ]
				}
                ActionItem {
                    id: ai_cancel
                    title: qsTr("Cancel")
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "asset:///icons/ic_cancel.png"
                    // When this action is selected, close the sheet
                    onTriggered: cancelDialog.show()
                    shortcuts: [
                        Shortcut {
                            key: "c"
                        }
                    ]
                    
                }
            } // end of ActionSet
        ]// end of contextActions list
        
        contextMenuHandler: ContextMenuHandler {
            id: cmh_handler
            // Abort the showing of the context menu if the user is interacting with the Image
            onPopulating: if (imageEditor.myImageElement.pinchHappening) event.abort(); else event;
            onVisualStateChanged: {
                // Don't allow dragging or pinching if Context Menu is shown
                if (ContextMenuVisualState.VisibleCompact == cmh_handler.visualState) {
                    imageEditor.myImageElement.pinchHappening = true;
                }
                else if (ContextMenuVisualState.Hidden == cmh_handler.visualState) {
                    imageEditor.myImageElement.pinchHappening = false;
                }
            }
        }
        
        attachedObjects: [
            SystemDialog {
                id: cancelDialog
                title: "Friendly Warning"
                body: qsTr("You're about to lose all your changes. Continue?")
                onFinished: if (cancelDialog.result == SystemUiResult.ConfirmButtonSelection) finishedEditting(); else cancelDialog;
            },
            HomeScreen {
                id: myHomeScreen
            },
            ComponentDefinition {
                id: cd_tutorialImage
                ImageView {
                    id: iv_tutorialFrame
                    scalingMethod: ScalingMethod.None
                    loadEffect: ImageViewLoadEffect.None
                    visible: true
                    opacity: 1.0
                    imageSource: "asset:///frames/fr_long_press.png"
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                console.log("[MultipleFramesEditor.iv_tutorialFrame.onTapped]");
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
                                // the tutorial image will remain invisible even after the user leaves the MFE.
                                iv_tutorialFrame.visible = false;
                                
                                // Don't show the tutorial image anymore
                                _appSettings.showTutorial = false;
                                
                                // remove this instance
                                controlDelegate.delegateActive = false;
                            }
                        }
                    ]
                }
            }
        ]
        layout: DockLayout { }

    }
    shortcuts: [
        Shortcut {
            key: "c"
            onTriggered: {
                console.log("[Shortcut] c");
                cancelDialog.show();
            }
        },
        Shortcut {
            key: "a"
            onTriggered: {
                showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),"asset:///frames/fr_active.png");
            }
        },
        Shortcut {
            key: "l"
            onTriggered: {
                showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_locked.png");
            }
        },
        Shortcut {
            key: "h"
            onTriggered: {
                showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),"asset:///frames/fr_home.png");
            }
        },
        Shortcut {
            key: "s"
            onTriggered: {
                saveImage();
            }
        },
        Shortcut {
            key: "w"
            onTriggered: {
                setAsDeviceWallpaper( saveImage() )
            }
        }
    ]
    
}
