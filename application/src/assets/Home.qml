import bb.cascades 1.0

Page {
    id: homeRootPage
    content: Container {
        background: Color.DarkGray
        layout: StackLayout {
        }
        Logo {
        }
        InlineImageBrowser {
        }
    }
    actions: [
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: "Share"
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
        },
        ActionItem {
            title: "Full Camera"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icons/ic_edit_profile.png"
            onTriggered: {
                // Switch to another tab from a TabbedPane
                //rootTabbedPane.activeTab = rootTabbedPane.at(1);

                if( _cameraManager.invokeCamera() == false){
                    console.log("[ERROR] Could not invoke the device Camera!");
                }
            }
        }
    ]
}
