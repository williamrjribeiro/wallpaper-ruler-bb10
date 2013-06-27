import bb.cascades 1.0

// It's better to work with JavaScript Object in separate js files. http://harmattan-dev.nokia.com/docs/library/html/qt4/qml-variant.html 
import "js/togglebuttonmanager.js" as ToggleButtonManager;

Page {
    id: mfeRootPage
    resizeBehavior: PageResizeBehavior.None
    signal finished()
    property alias image: imageEditor.image
    onCreationCompleted: {
        console.log("[MultipleFramesEditor.mfeRootPage.onCreationCompleted]");
        ToggleButtonManager.initToggleButtons([ai_homeFrame,ai_lockedFrame,ai_activeFrame]);
    }
    function showFrame(show,filePath){
        console.log("[MultipleFramesEditor.showFrame] show: "+show+", filePath: "+filePath);
        // TODO: the load effect is still playing! Maybe this is a Cascades bug.
        frameImage.resetLoadEffect();
        if(show){
            // TODO: this operation blocks the UI because the file is loaded from assets:/// so the fading effect doesn't run smoothly. 
            frameImage.imageSource = filePath;
            frameImage.opacity = 1.0;
        }
        else{
            frameImage.opacity = 0.0;
        }
    }
    Container {
        id: mainContainer
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.create(181,255,212,1)
        ImageEditor {
            id: imageEditor
            implicitLayoutAnimationsEnabled: false
        }
        ImageView {
            id: frameImage
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
        }
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
                }
                ActionItem {
                    id: ai_lockedFrame
                    objectName: "lockedFrameToggle"
                    title: qsTr("Locked Screen")
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_active.png");
                    }
                }
                ActionItem {
                    id: ai_activeFrame
                    objectName: "activeFrameToggle"
                    title: qsTr("Active Frame")
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),"asset:///frames/fr_active.png");
                    }
                }

				ActionItem {
				    id: saveActionItem
				    title: qsTr("Save")
				    ActionBar.placement: ActionBarPlacement.InOverflow
				    imageSource: "asset:///icons/ic_save.png"
				    onTriggered: {
				        console.log("[MultipleFramesEditor.saveActionItem.onTriggered]");
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
                        
                        finished();
                    }
                }
            } // end of ActionSet
        ]// end of contextActions list
        
        implicitLayoutAnimationsEnabled: false
        layout: DockLayout {}
    }
}
