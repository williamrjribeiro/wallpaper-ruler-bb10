import bb.cascades 1.0
NavigationPane {
    id: navigationPane
    property alias delegate: cdl_gifs
    Page {
        id: gifsRootPage
        actionBarVisibility: _screenSize.height == _screenSize.width ? ChromeVisibility.Overlay : ChromeVisibility.Visible
        ControlDelegate {
            id: cdl_gifs
            delegateActive: false
            sourceComponent: ComponentDefinition {
                InlineGifsBrowser {
                    id: gifsBrowser
                    onCreationCompleted: {
                        console.log("[Gifs.gifsBrowser.onCreationCompleted]");
                        grid.triggered.connect(onTriggered)
                    }
                    function onTriggered(){
                        console.log("[Gifs.gifsBrowser.onTriggered]");
                        gifViewer.setImageSource(selectedPath);
                        navigationPane.push(gifViewer);
                    }
                }            
            }
        }
        actions: [
            InvokeActionItem {
                ActionBar.placement: ActionBarPlacement.OnBar
                title: qsTr("Share")
                imageSource: "asset:///icons/ic_share.png"
                query {
                    mimeType: "text/plain"
                    invokeActionId: "bb.action.SHARE"
                    data: qsTr("Check out Wappy the happy wallpaper application! A #free and #native app for #bb10. http://appworld.blackberry.com/webstore/content/35353891/")
                }
            }
        ]
    }
    onPushTransitionEnded: {
        if(page == gifViewer){
	        OrientationSupport.supportedDisplayOrientation = 
	        SupportedDisplayOrientation.All;
	    }
    }
    onPopTransitionEnded: {
        gifViewer.scroller.resetViewableArea();
        OrientationSupport.supportedDisplayOrientation = 
        SupportedDisplayOrientation.DisplayPortrait;
    }
    backButtonsVisible: gifViewer.isPortrait;
    attachedObjects: [
        GifViewer{
            id: gifViewer
        }
    ]
}
