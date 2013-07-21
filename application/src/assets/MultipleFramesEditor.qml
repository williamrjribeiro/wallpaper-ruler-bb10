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
    property alias tutorial: iv_tutorialFrame
    onCreationCompleted: {
        console.log("[MultipleFramesEditor.mfeRootPage.onCreationCompleted]");
        ToggleButtonManager.initToggleButtons([ai_homeFrame,ai_lockedFrame,ai_activeFrame]);
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
    Container {
        id: mainContainer
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        implicitLayoutAnimationsEnabled: false
        background: Color.create(181,255,212,1)
        
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
        
        ImageView {
            id: iv_tutorialFrame
            // Only show the Tutorial Image if it's the first time the user runs the app
            opacity: _appSettings.lastClosed == "" ? 1.0 : 0.0
            visible: _appSettings.lastClosed == "" ? true : false
            scalingMethod: ScalingMethod.None
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_long_press.png"
            onTouch: {
                console.log("[MultipleFramesEditor.iv_tutorialFrame.onTouch] event.isUp: " + event.isUp());
                if(event.isUp()){
                    trans_fadeOut.play();
                }
            }
            animations: [
                FadeTransition {
                    id: trans_fadeOut
                    fromOpacity: 1.0
                    toOpacity: 0.0
                    onEnded: {
                        // the tutorial image will remain invisible even after the user leaves the MFE.
                        iv_tutorialFrame.visible = false;
                    }
                }
            ]
        }
        focusPolicy: FocusPolicy.KeyAndTouch
        
        contextActions: [
            ActionSet {
                title: qsTr("Frames")
                subtitle: qsTr("The frames help you fit your images")
                ActionItem {
                    id: ai_homeFrame
                    objectName: "homeFrameToggle"
                    title: qsTr("Home Screen")
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),"asset:///frames/fr_home.png");
                    }
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
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_locked.png");
                    }
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
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),"asset:///frames/fr_active.png");
                    }
                    shortcuts: [
                        Shortcut {
                            key: "a"
                        }
                    ]
                }
				ActionItem {
				    id: saveActionItem
				    title: qsTr("Save")
				    ActionBar.placement: ActionBarPlacement.InOverflow
				    imageSource: "asset:///icons/ic_save.png"
				    onTriggered: {
				        console.log("[MultipleFramesEditor.saveActionItem.onTriggered]");
                        var savedImage = _imageEditor.processImage(imageEditor.myImageElement.imageSource, imageEditor.myImageElement.scaleX, imageEditor.myImageElement.translationX, imageEditor.myImageElement.translationY,imageEditor.myImageElement.rotationZ);
                        if (savedImage == ""){
                            console.log("error saving image");
                        }else {
                            var result = myHomeScreen.setWallpaper("file://" + savedImage);
                            _imageGridDataProvider.addImage("file://" + savedImage);
                        }
                        console.log(result);
				    }
				}
				ActionItem {
				    id: saveAsActionItem
				    title: qsTr("Save as...")
				    ActionBar.placement: ActionBarPlacement.InOverflow
				    imageSource: "asset:///icons/ic_save_as.png"
				    onTriggered: {
                        console.log("[MultipleFramesEditor.saveAsActionItem.onTriggered]");
				    }
				}
                ActionItem {
                    id: finishedActionItem
                    title: qsTr("Cancel")
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "asset:///icons/ic_cancel.png"
                    // When this action is selected, close the sheet
                    onTriggered: {
                        console.log("[MultipleFramesEditor.finishedActionItem.onTriggered]");
                        cancelDialog.show();
                    }
                    shortcuts: [
                        Shortcut {
                            key: "c"
                        }
                    ]
                    
                }
            } // end of ActionSet
        ]// end of contextActions list
        
        attachedObjects: [
            SystemDialog {
                id: cancelDialog
                title: "Friendly Warning"
                body: qsTr("You're about to lose all your changes. Continue?")
                onFinished: {
                    if (cancelDialog.result == SystemUiResult.ConfirmButtonSelection){
                        finishedEditting();
                    }                        
                }
            },
            HomeScreen {
                id: myHomeScreen
            }
        ]
        layout: DockLayout {

        }

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
        }
    ]
    
}
