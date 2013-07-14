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
                ImageView {
                    imageSource: ListItemData
                    scalingMethod: ScalingMethod.AspectFill
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        ] // listItemComponents

        onTriggered: {
            console.log("[InlineImageBrowser.imagesList.onTriggered] indexPath: " + indexPath);
            selectedPath = _imageGridDataProvider.dataModel.data( indexPath );
            mfeSheet.open();
        }
    }
    property string selectedPath;
    
    attachedObjects: [
        Sheet {
            id: mfeSheet
            content: MultipleFramesEditor {
                id: mfeContent
            }
            onOpened: {
                console.log("[InlineImageBrowser.mfeSheet.onOpened] selectedPath: " + selectedPath);
                mfeContent.imageEditor.image.imageSource = selectedPath;
            }
            onClosed: {
                console.log("[InlineImageBrowser.mfeSheet.onClosed]");
                mfeContent.imageEditor.resetEdits();
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
        mfeContent.finishedEditting.connect( handleMFEFinished );
        
        // Connect the onImageCaptured Signal from the CameraManager to our Slot so it shows the imageEditor.image.
        _cameraManager.imageCaptured.connect( onImageCaptured );
    }
    
    property bool imageCaptured: false
    function onImageCaptured(imagePath) {
        console.log("[InlineImageBrowser.onImageCaptured] imagePath: " + imagePath);
        //mfeContent.imageEditor.image.imageSource = imagePath;
        selectedPath = imagePath;
        imageCaptured = true;
        mfeSheet.open();
    }
    
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished] imageCaptured: "+imageCaptured);
        
        mfeSheet.close();
        
        // TODO: remove the code that re-opens the Camera.
        /*if(imageCaptured){
            imageCaptured = false;
            _cameraManager.invokeCamera();
        }
        */
    }
}
