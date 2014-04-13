import bb.cascades 1.0
Container {
        id: imagesGridContainer
        layout: DockLayout {}
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.Black

        property string selectedPath
        property alias grid: imageGrid

        ControlDelegate {
            id: cdl_emptyGrid
            delegateActive: false
            sourceComponent: ComponentDefinition {
                Container {
                    id: ctn_empty
                    background: Color.Black
                    layout: DockLayout {
                    }
                    topPadding: 40.0
                    rightPadding: 20.0
                    leftPadding: 20.0
                    bottomPadding: 140.0
                    preferredWidth: _screenSize.width
                    preferredHeight: _screenSize.height
                    onTouch: fallAnimation.play()
                    Label {
                        text: qsTr("No GIFs found on your device. Try downloading some from the internet")
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
            
            dataModel: _gifsGridDataProvider.dataModel
    
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
	            selectedPath = _gifsGridDataProvider.getImageURL( indexPath );
	            console.log("[InlineGifsBrowser.imageGrid.onTriggered] indexPath:",indexPath,", selectedPath:",selectedPath);
	        }
	    } // end ListView
	    
	    onCreationCompleted: {
	        console.log("[InlineGifsBrowser.onCreationCompleted]");
	        
	        // this signal is dispatched when the user taps on Finished/Cancel from gif.
	        // It must go back to this screen
	        //gifViewer.finishedEditting.connect( handleGIFFinished );
	        
	        // Load the empty container only there's no images on the device
	        if(_gifsGridDataProvider.imagesCount == 0){
	            cdl_emptyGrid.delegateActive = true;
	            imageGrid.visible = false;
	        }
	        else {
	            _gifsGridDataProvider.loadMoreImages();
	        }
	    }
}// end of NavigationPane
