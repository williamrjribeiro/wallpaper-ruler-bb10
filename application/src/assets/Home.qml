import bb.cascades 1.0

Page {
    id: homeRootPage
    content: Container {
        background: Color.DarkGray
        layout: StackLayout {
        }
        Logo {
        }
        Label {
            text: "This is the HOME tab!"
        }
        InlineImagePicker {
        }
    }
    actions: [
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            title: "Share"
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
            onTriggered: {
            
            }
        }
    ]
}
