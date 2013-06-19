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
                        scalingMethod: ScalingMethod.AspectFill
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
        
        // this signal is dispatched when the user taps on Finished/Cancel.
        // It must go back to the previous state.
        mfeContent.finished.connect( handleMFEFinished );
        
        // Connect the onImageCaptured Signal from the CameraManager to our Slot so it shows the image.
        _cameraManager.imageCaptured.connect( onImageCaptured );
    }
    
    property bool imageCaptured: false
    function onImageCaptured(imagePath) {
        console.log("[InlineImageBrowser.onImageCaptured] imagePath: " + imagePath);
        mfeContent.image.imageSource = imagePath;
        imageCaptured = true;
        mfeSheet.open();
    }
    
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished] imageCaptured: "+imageCaptured);
        mfeSheet.close();
        if(imageCaptured){
            imageCaptured = false;
            _cameraManager.invokeCamera();
        }
    }
}
