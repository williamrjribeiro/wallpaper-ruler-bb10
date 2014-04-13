import bb.cascades 1.0

Container {
    id: imagesGridContainer
    layout: DockLayout {}
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    
    property string selectedPath;
    property bool imageCaptured: false
    
    ControlDelegate {
        id: cdl_emptyGrid
        delegateActive: false
        sourceComponent: ComponentDefinition {
            Container {
                id: ctn_empty
                background: Color.Black;
                layout: DockLayout {}
                topPadding: 40.0
                rightPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 140.0
                preferredWidth: _screenSize.width
                preferredHeight: _screenSize.height
                onTouch: fallAnimation.play()
                Label {
                    text: qsTr("No images found on your device. Try taking some pictures!")
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top
                    textStyle.color: Color.White
                    multiline: true
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.Large
                    autoSize.maxLineCount: 4
                }
                ImageView {
                    id: imv_empty
                    imageSource: "images/empty.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Bottom
                    onCreationCompleted: fallAnimation.play()
                    opacity: 0.0
                    implicitLayoutAnimationsEnabled: false
                    animations: [
                        ParallelAnimation {
                            id: fallAnimation
                            FadeTransition {
                                fromOpacity: 0.0
                                toOpacity: 1.0
                                duration: 1000.0
                            }
                            TranslateTransition {
                                repeatCount: 1
                                easingCurve: StockCurve.BounceOut
                                duration: 1000.0
                                fromY: - _screenSize.height
                                toY: 0.0
                            }
                        }
                    ]
                }
            } // End of ctn_empty
        }
    }
    
    ListView {
        id: imageGrid
        visible: true;
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
	            ImageView {
	                image: ListItemData.image
                    opacity: ListItemData.loading ? 0.0 : 1.0
                    scalingMethod: ScalingMethod.AspectFill
	                verticalAlignment: VerticalAlignment.Center
	                horizontalAlignment: HorizontalAlignment.Center
	            }
	        }
        }

        onTriggered: {
            selectedPath = _imageGridDataProvider.getImageURL( indexPath );
            console.log("[InlineImageBrowser.imageGrid.onTriggered] indexPath:",indexPath,", selectedPath:",selectedPath);
            // step 1: set the image path on the ImageView of the ImageEditor so that it's loaded
            mfeContent.setImageSource(selectedPath);
        }
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
        
        // Load the empty container only there's no images on the device
        if(_imageGridDataProvider.imagesCount == 0){
            cdl_emptyGrid.delegateActive = true;
            imageGrid.visible = false;
        }
        else {
            _imageGridDataProvider.loadMoreImages();
        }
    }
    
    function onImageCaptured(imagePath) {
        console.log("[InlineImageBrowser.onImageCaptured] imagePath: " + imagePath);
        selectedPath = "file://" + imagePath;
        imageCaptured = true;    
        
        // step 1: set the image path on the ImageView of the ImageEditor so that it's loaded
        mfeContent.setImageSource(selectedPath);

        _imageGridDataProvider.addImage(imagePath);
        
        imageGrid.visible = true;
        
        // unload the empty container after taking a picture so that the ListView (grid) can appear
        cdl_emptyGrid.delegateActive = false;
    }
    
    function handleMFEFinished() {
        console.log("[InlineImageBrowser.handleMFEFinished] imageCaptured: "+imageCaptured);
        mfeSheet.close();
    }
}
