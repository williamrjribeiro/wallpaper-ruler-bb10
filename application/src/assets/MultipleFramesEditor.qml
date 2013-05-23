import bb.cascades 1.0

Page {
    id: mfeRootPage
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
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        animations: [
            // A translation animation that moves the image
            // downwards by a small amount
            TranslateTransition {
                id: translateAnimation
                toY: 150
                duration: 1000
            },
            
            // A rotation animation that spins the image
            // by 180 degrees
            RotateTransition {
                id: rotateAnimation
                toAngleZ: 180
                duration: 1000
            },
            
            // A scaling animation that increases the size
            // of the image by a factor of 2 in both the
            // x and y directions
            ScaleTransition {
                id: scaleAnimation
                toX: 2.0
                toY: 2.0
                duration: 1000
            },

            // A scaling animation that reduces the size
            // of the image by a factor of 2 in both the
            // x and y directions
            ScaleTransition {
                id: shrinkAnimation
                toX: 1.0
                toY: 1.0
                duration: 1000
            }
        ]
        contextActions: [
            ActionSet {
                title: "Animations"
                subtitle: "Choose your animation"
                
                // This action plays the translation animation
                ActionItem {
                    title: "Slide"
                    onTriggered: {
                        translateAnimation.play();
                    }
                }
                
                // This action plays the rotation animation
                ActionItem {
                    title: "Spin"
                    onTriggered: {
                        rotateAnimation.play();
                    }
                }
                
                // This is a ActionItem that behaves like a toggle button: it grows and shrinks the image.
                ActionItem {
                    title: toggled ? "Normal" : "Big"
                    imageSource: toggled ? "asset:///icons/ic_info.png" : "asset:///icons/ic_share.png"
                    onTriggered: {
                        if( toggled ){
                            shrinkAnimation.play();
                        }
                        else{
                            scaleAnimation.play();
                        }
                        toggled = ! toggled;
                    }
                }

                ActionItem {
                    id: finishedActionItem
                    title: "Finished"
                    ActionBar.placement: ActionBarPlacement.InOverflow

                    // When this action is selected, close
                    // the sheet
                    onTriggered: {
                        console.log("[MultipleFramesEditor.finishedActionItem.onTriggered]");
                        finished();
                    }
                }
            } // end of ActionSet
        ] // end of contextActions list
    }
}
