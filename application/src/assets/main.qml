// Default empty project template
import bb.cascades 1.0

TabbedPane {
    id: rootTabbedPane
    showTabsOnActionBar: false
    Tab {
        title: "Home"
        imageSource: "asset:///icons/ic_bbm.png"
        content: Home {
        }
    }
    
    Tab {
        title: "Camera"
        imageSource: "asset:///icons/ic_edit_profile.png"
        content: Camera {
        }
    }
    
    Tab {
        title: "Tutorials"
        imageSource: "asset:///icons/ic_info.png"
        content: Tutorials {
        }
    }
    
    Tab {
        title: "Creators"
        content: About {
        }
    }
    
    Tab {
        title: "Change Log"
        content: Tutorials {
        }
    }

} // end of rootTabbedPane
