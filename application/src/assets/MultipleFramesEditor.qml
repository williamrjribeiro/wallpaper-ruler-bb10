import bb.cascades 1.0

Page {
    id: mfeRootPage
    signal finished()
    property alias image: imageEditor.image
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
    }
    actions: [
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
    ]
}
