import bb.cascades 1.0

Page {
    property alias delegate: cdl_changeLog
    Container {
        layout: DockLayout {}
        ControlDelegate {
            id: cdl_changeLog
            delegateActive: false;
            sourceComponent: cdf_changeLog
        }
        attachedObjects: [
            ComponentDefinition {
                id: cdf_changeLog
                ScrollView {
                    content: WebView {
                        id: webView
                        topPadding: 150
                        url: "local:///assets/html/changelog.html"
                        settings.javaScriptEnabled: false
                        settings.minimumFontSize: 5
                        settings.cookiesEnabled: false
                        settings.binaryFontDownloadingEnabled: false
                    }
                    scrollViewProperties.scrollMode: ScrollMode.Vertical
                    scrollViewProperties.pinchToZoomEnabled: false
                    scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.OnScroll // end WebView 
                }
                
            } // end ComponentDefinition
        ] // end attachedObjects
    }
}
