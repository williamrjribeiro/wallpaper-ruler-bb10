import bb.cascades 1.0

Container {
    id: imagesGridContainer
    // Main List
    ListView {
        id: imagesList

        layout: GridListLayout {
            columnCount: 3
            headerMode: ListHeaderMode.None
            verticalCellSpacing: 25
            horizontalCellSpacing: 22
        }
        
        leftPadding: 30
        rightPadding: 30
        topPadding: 20

        dataModel: _imageGridDataProvider.dataModel

        listItemComponents: [
            // The image Item
            ListItemComponent {
                content: Container {
                    id: itemRoot
                    ImageView {
	                    imageSource: ListItemData
                        scalingMethod: ScalingMethod.None
	                    verticalAlignment: VerticalAlignment.Center
	                    horizontalAlignment: HorizontalAlignment.Center
	                }
                }
            }
        ] // listItemComponents

        onTriggered: {
            mfeContent.image.imageSource = _imageGridDataProvider.dataModel.data( indexPath );
            mfeSheet.open();
        }
    }
    attachedObjects: [
        Sheet {
            id: mfeSheet
            content: MultipleFramesEditor {
                id: mfeContent
            }
            onOpened: {
                
            }
        }    
    ]
    layout: DockLayout {
    }
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    onCreationCompleted: {
        mfeSheet.peekEnabled = false;
        mfeContent.finished.connect( handleMFEFinished );
    }
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished]");
        mfeSheet.close();
    }
}
