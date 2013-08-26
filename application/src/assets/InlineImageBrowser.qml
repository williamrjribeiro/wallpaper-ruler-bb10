import bb.cascades 1.0

Container {
    id: imagesGridContainer
    layout: DockLayout {}
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    
    property string selectedPath;
    property bool imageCaptured: false
    
    ListView {
        id: imageGrid

        layout: GridListLayout {
            columnCount: 3
            headerMode: ListHeaderMode.None
            verticalCellSpacing: 10
            horizontalCellSpacing: 10
        }
        
        dataModel: _imageGridDataProvider.dataModel

		listItemComponents: ListItemComponent {
            Container {
                layout: DockLayout {}
                
                // The loading image that is only rotating and visible while the image is loading
                ImageView {
                    imageSource: "images/loading.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    preferredHeight: 90
                    preferredWidth: 90
                    visible: ListItemData.loading
                    animations: [
                        RotateTransition {
                            id: rotateAnimation
                            toAngleZ: 360
                            duration: 1000
                            repeatCount: AnimationRepeatCount.Forever 
                        }
                    ]
                    onCreationCompleted: rotateAnimation.play()
                    onVisibleChanged: visible ? rotateAnimation.play() : rotateAnimation.stop()
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
            console.log("[InlineImageBrowser.imageGrid.onTriggered] indexPath: " + indexPath);
            selectedPath = _imageGridDataProvider.getImageURL( indexPath );
            // step 1: set the image path on the ImageView of the ImageEditor so that it's loaded
            mfeContent.imageSource = selectedPath;
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
    } // end ListView
    
    attachedObjects: [
        Sheet {
            id: mfeSheet
            peekEnabled: false 
            content: MultipleFramesEditor {
                id: mfeContent
                onCreationCompleted: {
                    console.log("[InlineImageBrowser.mfeSheet.mfeContent.onCreationCompleted]");
                    // Open the page once the imageReady signal is emmited. This means the image has finished loading and it's scaled.
                    imageEditor.imageReady.connect(mfeSheet.open);
                }
            }
            onClosed: {
                console.log("[InlineImageBrowser.mfeSheet.onClosed]");
                mfeContent.imageEditor.resetEdits();
                _imageGridDataProvider.loadMoreImages();
            }
        }    
    ]
    
    onCreationCompleted: {
        console.log("[InlineImageBrowser.onCreationCompleted]");
        
        // this signal is dispatched when the user taps on Finished/Cancel from MFE.
        // It must go back to this screen
        mfeContent.finishedEditting.connect( handleMFEFinished );
        
        // Connect the onImageCaptured Signal from the CameraManager to our Slot so it shows the imageEditor.image.
        _cameraManager.imageCaptured.connect( onImageCaptured );
    }
    
    function onImageCaptured(imagePath) {
        console.log("[InlineImageBrowser.onImageCaptured] imagePath: " + imagePath);
        selectedPath = "file://" + imagePath;
        imageCaptured = true;    
        
        // step 1: set the image path on the ImageView of the ImageEditor so that it's loaded
        mfeContent.imageSource = selectedPath;

        _imageGridDataProvider.addImage(imagePath);
    }
    
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished] imageCaptured: "+imageCaptured);
        mfeSheet.close();
    }
}
