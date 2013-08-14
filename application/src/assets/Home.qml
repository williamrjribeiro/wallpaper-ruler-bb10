import bb.cascades 1.0

Page {
    id: homeRootPage
    content: Container {
        background: Color.DarkGray
        layout: StackLayout {
        }
        InlineImageBrowser {
        }
    }
    actions: [
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            title: "Share"
            imageSource: "asset:///icons/ic_share.png"
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
        },
        ActionItem {
            title: qsTr("Camera")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icons/ic_camera.png"
            onTriggered: {
                if( _cameraManager.invokeCamera() == false){
                    console.log("[ERROR] Could not invoke the device Camera!");
                }
            }
        },
        ActionItem {
            title: qsTr("Ponyo")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///icons/ic_camera.png"
        }
    ]
}
