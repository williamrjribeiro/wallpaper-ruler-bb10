import bb.cascades 1.0

Page {
    id: homeRootPage
    property alias delegate: cdl_home
    actionBarVisibility: _screenSize.height == _screenSize.width ? ChromeVisibility.Overlay : ChromeVisibility.Visible
    ControlDelegate {
        id: cdl_home
        delegateActive: true
        sourceComponent: ComponentDefinition {
            Container {
                background: Color.Black
                InlineImageBrowser {
                }
            }
        }
    }
    actions: [
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Share")
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
            onTriggered: _cameraManager.invokeCamera()
        }
    ]
}
