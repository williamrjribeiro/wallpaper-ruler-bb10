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
            title: "Camera"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icons/ic_edit_profile.png"
            onTriggered: {
                rootTabbedPane.activeTab = rootTabbedPane.at(1);
            }
        }
    ]
}
