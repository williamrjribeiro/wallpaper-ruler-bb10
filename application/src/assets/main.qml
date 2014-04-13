import bb 1.0
import bb.cascades 1.0

TabbedPane {
    id: rootTabbedPane
    showTabsOnActionBar: false
    Tab {
        id: homeTab
        title: qsTr("Gallery")
        imageSource: "asset:///icons/ic_gallery.png"
        content: Home {
        }
        onTriggered: content.delegate.delegateActive = true
    }
    
    Tab {
        id: teaserTab
        title: qsTr("Wappy Camera")
        imageSource: "asset:///icons/ic_wappy_camera.png"
        content: Teaser {
        }
        onTriggered: content.delegate.delegateActive = true
    }
    
   Tab {
        id: gifTab
        title: qsTr("Gif Viewer")
        imageSource: "asset:///icons/ic_wappy_camera.png"
        content: Gifs {
        }
        onTriggered: content.delegate.delegateActive = true
    }
   
    Tab {
        id: changeLogTab
        title: qsTr("Change Log")
        imageSource: "asset:///icons/ic_change_log.png"
        content: ChangeLog {
        }
        onTriggered: content.delegate.delegateActive = true
    }
    
    onCreationCompleted: {
        OrientationSupport.supportedDisplayOrientation = 
        SupportedDisplayOrientation.DisplayPortrait;
    }
    
    attachedObjects: [
        MemoryInfo {
            id: memoryInfo
            onLowMemory: {
                console.log("[main.memoryInfo.onLowMemory] level:", level, ", activeTab.title:", activeTab.title);
                if (level == LowMemoryWarningLevel.LowPriority) {
                    // unload all tabs except for the active one
                    if (activeTab != homeTab) {
                        homeTab.content.delegate.delegateActive = false;
                    }
                    if(activeTab != teaserTab){
                    	teaserTab.content.delegate.delegateActive = false;
                    }
                    if (activeTab != gifTab) {
                        gifTab.content.delegate.delegateActive = false;
                    }
                    if (activeTab != changeLogTab) {
                        changeLogTab.content.delegate.delegateActive = false;
                    }
                }
            }
        }
    ]

}// end of rootTabbedPane
