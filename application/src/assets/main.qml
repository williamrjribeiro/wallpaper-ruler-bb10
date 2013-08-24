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
        content: ChangeLog {
        }
    }
    
    // Disabling Custom Camera for now
    onActiveTabChanged: {
        if(activeTab === changeLogTab){
            changeLogTab.content.changeLog.delegateActive = true;
        }
        else if(activeTab === creatorsTab){
            creatorsTab.content.creators.delegateActive = true;
        }
    }

} // end of rootTabbedPane
