import bb.cascades 1.0

Page {
    id: mfeRootPage
    resizeBehavior: PageResizeBehavior.None
    signal finished()
    property alias image: imageEditor.image
    property bool toggled: false
    Container {
        id: mainContainer
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.create(181,255,212,1)
        ImageEditor {
            id: imageEditor
            implicitLayoutAnimationsEnabled: false
        }
        contextActions: [
            ActionSet {
                title: "Frames"
                subtitle: "The frames help you fit your images"
                
                // This action plays the translation animation
                ActionItem {
                    title: "Locked Screen Frame"
                    onTriggered: {
                        console.log("[MultipleFramesEditor.lockedFrameActionItem.onTriggered]");
                    }
                }
                
                // This action plays the rotation animation
                ActionItem {
                    title: "Home Screen Frame"
                    onTriggered: {
                        console.log("[MultipleFramesEditor.homeFrameActionItem.onTriggered]");
                    }
                }
                
                // This is a ActionItem that behaves like a toggle button: it grows and shrinks the image.
                ActionItem {
                    title: "Active Frame"
                    imageSource: toggled ? "asset:///icons/ic_info.png" : "asset:///icons/ic_share.png"
                    onTriggered: {
                        toggled = ! toggled;
                        console.log("[MultipleFramesEditor.activeFrameActionItem.onTriggered] toggled: "+toggled);
                    }
                }

                ActionItem {
                    id: finishedActionItem
                    title: "Finished"
                    ActionBar.placement: ActionBarPlacement.InOverflow

                    // When this action is selected, close the sheet
                    onTriggered: {
                        console.log("[MultipleFramesEditor.finishedActionItem.onTriggered]");
                        finished();
                    }
                }
            } // end of ActionSet
        ]
        implicitLayoutAnimationsEnabled: false
        layout: DockLayout {

        }        // end of contextActions list
    }
}
