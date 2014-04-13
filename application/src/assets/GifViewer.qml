import bb.cascades 1.0

Page {
    property alias gifViewer: webViewer
    property alias scroller: scrollView
    property bool isPortrait: true;
    titleBar: TitleBar {
        id: title
        appearance: TitleBarAppearance.Plain
    }
    function setImageSource(filePath){
        // ignore the file:/// protocol
        var folders = filePath.substring(8).split('/'),
        	fileName = folders[folders.length - 1],
        	parentsName = "";
        
        // Start gathering the parent folders from the "shared" folder.
        for(var i = folders.indexOf("shared") + 1, l = folders.length - 1; i < l; i++){
            parentsName += (folders[i] + "/"); 
        }
        
        console.log("[GifViewer.setImageSource] parentsName:",parentsName,", fileName:",fileName,", filePath:",filePath);
        
        title.title = parentsName + fileName;
        
        // http://24.media.tumblr.com/d61151e058de046bc7f0bf17bfe3c412/tumblr_n3zjrb8mW11ro5xweo1_400.gif
        webViewer.postMessage(filePath);
    }
    
    Container {
        layout: DockLayout {}
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.Black
        ScrollView {
            id: scrollView
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            content: WebView {
                id: webViewer
                url: "file:///" + homeDir + "/assets/html/gifviewer.html"
                settings.background: Color.Black
                settings.javaScriptEnabled: true
                settings.viewport: {
                    "width" : "device-width",
                    "height" : "device-height", 
                    "initial-scale" : 1.0
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            } // End of WebView
            scrollViewProperties.pinchToZoomEnabled: true
            scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.OnPinchAndScroll
            scrollViewProperties.scrollMode: ScrollMode.Both
        }
    }
    attachedObjects: [
        OrientationHandler {
            id: handler
            // Call update function to set new orientation
            onOrientationAboutToChange: {
                if(orientation == UIOrientation.Landscape){
                    title.visibility = ChromeVisibility.Hidden;
                    isPortrait = false;                   
                }
                else {
                    title.visibility = ChromeVisibility.Visible;
                    isPortrait = true;
                }
            }
        }
    ]
}
