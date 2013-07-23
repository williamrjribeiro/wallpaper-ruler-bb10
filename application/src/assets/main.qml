// Default empty project template
import bb.cascades 1.0

TabbedPane {
    id: rootTabbedPane
    showTabsOnActionBar: false
    Tab {
        id: homeTab
        title: qsTr("Home")
        imageSource: "asset:///icons/ic_home.png"
        content: Home {
        }
    }
    
    Tab {
        id: teaserTab
        title: qsTr("Wappy Camera")
        imageSource: "asset:///icons/ic_edit_profile.png"
        content: Teaser {
        }
    }
    
    // Disabling Custom Camera for now
    /*
    Tab {
        id: customCamera
        title: "Custom Camera"
        imageSource: "asset:///icons/ic_edit_profile.png"
        content: CustomCamera {
        }
    }
    */
    // Disabling Tutorials page for now
    /*
    Tab {
        id: tutorialsTab
        title: "Tutorials"
        imageSource: "asset:///icons/ic_info.png"
        content: Tutorials {
        }
    }
    */
    
    Tab {
        id: creatorsTab
        title: qsTr("Creators")
        imageSource: "asset:///icons/ic_creators.png"
        content: About {
        }
    }
    
    Tab {
        id: changeLogTab
        title: qsTr("Change Log")
        imageSource: "asset:///icons/ic_change_log.png"
        content: Tutorials {
        }
    }
    
    // Disabling Custom Camera for now
    /*onActiveTabChanged: {
        if(activeTab != customCamera){
            customCamera.content.shutDownCamera();
            
            // TODO: we always show the tutorial image but it should only show when needed.
            customCamera.content.tutorial.visible = true;
            customCamera.content.tutorial.opacity = 1.0;
        }
    }*/

} // end of rootTabbedPane
