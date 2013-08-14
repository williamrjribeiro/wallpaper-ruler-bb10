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

		listItemComponents: ListItemComponent {
            Container {
                layout: DockLayout {}
                
                // The ActivityIndicator that is only active and visible while the image is loading
                ActivityIndicator {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    preferredHeight: 150
                    
                    visible: ListItemData.loading
                    running: ListItemData.loading
                }
	            ImageView {
	                image: ListItemData.image
                    visible: !ListItemData.loading
	                scalingMethod: ScalingMethod.AspectFill
	                verticalAlignment: VerticalAlignment.Center
	                horizontalAlignment: HorizontalAlignment.Center
	            }
	        }
        }

        onTriggered: {
            console.log("[InlineImageBrowser.imagesList.onTriggered] indexPath: " + indexPath);
            selectedPath = _imageGridDataProvider.getImageURL( indexPath );
            // step 1: set the image path on the ImageView of the ImageEditor so that it's loaded
            mfeContent.imageEditor.image.imageSource = selectedPath;
            
            // step 2: Open the page once the imageReady signal is emmited. This means the image has finished load and it's scaled.
            mfeContent.imageEditor.imageReady.connect(mfeSheet.open);
        }
        
        attachedObjects: [
            ListScrollStateHandler {
                id: gridViewScrollStateHandler
                onAtEndChanged: {
                    if(atEnd){
                    	_imageGridDataProvider.loadMoreImages();
                    }
                }
            }
        ]
    }
    property string selectedPath;
    
    attachedObjects: [
        Sheet {
            id: mfeSheet
            peekEnabled: false 
            content: MultipleFramesEditor {
                id: mfeContent
            }
            onClosed: {
                console.log("[InlineImageBrowser.mfeSheet.onClosed]");
                mfeContent.imageEditor.resetEdits();
                
                _imageGridDataProvider.loadMoreImages();
            }
        }    
    ]
    layout: DockLayout {
    }
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    onCreationCompleted: {
        
        console.log("[InlineImageBrowser.onCreationCompleted]");
        
        // this signal is dispatched when the user taps on Finished/Cancel.
        // It must go back to this screen
        mfeContent.finishedEditting.connect( handleMFEFinished );
        
        // Connect the onImageCaptured Signal from the CameraManager to our Slot so it shows the imageEditor.image.
        _cameraManager.imageCaptured.connect( onImageCaptured );
    }
    
    property bool imageCaptured: false
    function onImageCaptured(imagePath) {
        console.log("[InlineImageBrowser.onImageCaptured] imagePath: " + imagePath);
        selectedPath = "file://" + imagePath;
        imageCaptured = true;
        mfeSheet.open();
        
        _imageGridDataProvider.addImage(imagePath);
    }
    
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished] imageCaptured: "+imageCaptured);
        mfeSheet.close();
    }
}
