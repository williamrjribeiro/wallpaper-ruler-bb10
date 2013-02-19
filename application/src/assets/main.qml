// Default empty project template
import bb.cascades 1.0

TabbedPane {
    id: rootTabbedPane
    showTabsOnActionBar: true
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
        title: "About Us"
        imageSource: "asset:///icons/ic_info.png"
        content: About {
        }
    }
    Tab {
        title: "Tutorial"
        content: Page {
            content: Label {
                text: "Tutorials"
            }
        }
    }
    Tab {
        title: "Creators"
        content: Page {
            content: Label {
                text: "Creators"
            }
        }
    }
    Tab {
        title: "Change Log"
        content: Page {
            content: Label {
                text: "Change Log"
            }
        }
    }

} // end of rootTabbedPane
