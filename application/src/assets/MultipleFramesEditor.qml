import bb.cascades 1.0
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
        frameImage.loadEffect = ImageViewLoadEffect.None;
        if(show){
            frameImage.imageSource = filePath;
            frameImage.opacity = 1.0
        }
        else{
            frameImage.opacity = 0.0
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
            enabled: false
        }
        contextActions: [
            ActionSet {
                title: qsTr("Frames")
                subtitle: qsTr("The frames help you fit your images")

                // This is a ActionItem that behaves like a toggle button: it grows and shrinks the image.
                ActionItem {
                    id: ai_homeFrame
                    objectName: "homeFrameToggle"
                    title: qsTr("Home Screen")
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),"asset:///frames/fr_active.png");
                    }
                }
                
                // This is a ActionItem that behaves like a toggle button: it grows and shrinks the image.
                ActionItem {
                    id: ai_lockedFrame
                    objectName: "lockedFrameToggle"
                    title: qsTr("Locked Screen")
                    imageSource: "asset:///icons/ic_checkbox.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_active.png");
                    }
                }
                
                // This is a ActionItem that behaves like a toggle button: it grows and shrinks the image.
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
