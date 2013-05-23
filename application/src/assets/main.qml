// Default empty project template
import bb.cascades 1.0

TabbedPane {
    id: rootTabbedPane
    showTabsOnActionBar: false
    Tab {
        id: homeTab
        title: "Home"
        imageSource: "asset:///icons/ic_bbm.png"
        content: Home {
        }
    }
    
    Tab {
        id: customCamera
        title: "Custom Camera"
        imageSource: "asset:///icons/ic_edit_profile.png"
        content: CustomCamera {
        }
    }
    
    Tab {
        id: tutorialsTab
        title: "Tutorials"
        imageSource: "asset:///icons/ic_info.png"
        content: Tutorials {
        }
    }
    
    Tab {
        id: creatorsTab
        title: "Creators"
        content: About {
        }
    }
    
    Tab {
        id: changeLogTab
        title: "Change Log"
        content: Tutorials {
        }
    }
    
    onActiveTabChanged: {
        if(activeTab != customCamera){
            customCamera.content.shutDownCamera();
        }
    }

} // end of rootTabbedPane
