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
                        settings.defaultTextCodecName: "utf-8"
                        onNavigationRequested: {
                            console.log("[ChangeLog.webView.onNavigationRequested] request.navigationType:",request.navigationType,", request.url: ",request.url);
                            if(request.navigationType == WebNavigationType.LinkClicked){
	                            // don't let the Webview navigate to the requested page
	                            request.action = WebNavigationRequestAction.Ignore
	                            // will auto-invoke after re-arming
	                            linkInvocation.query.uri = request.url
	                        }   
                        }
                        attachedObjects: [
                            Invocation {
                                id: linkInvocation
                                property bool auto_trigger: false
                                query {
                                    uri: "http://www.williamrjribeiro.com"
                                    onUriChanged: {
                                        linkInvocation.query.updateQuery();
                                    }
                                }
                                onArmed: {
                                    // don't auto-trigger on initial setup
                                    if (auto_trigger)
                                        trigger("bb.action.OPEN");
                                    auto_trigger = true;    // allow re-arming to auto-trigger
                                }
                            }
                        ]
                    } // End of webView
                    scrollViewProperties.scrollMode: ScrollMode.Vertical
                    scrollViewProperties.pinchToZoomEnabled: false
                    scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.OnScroll 
                }
                
            } // end ComponentDefinition
        ] // end attachedObjects
    }
}
