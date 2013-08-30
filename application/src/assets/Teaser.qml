import bb.cascades 1.0

Page {
    property alias delegate: cdl_teaser
    ControlDelegate {
        id: cdl_teaser
        delegateActive: false;
        sourceComponent: ComponentDefinition {
            Container {
                background: Color.Black
                ImageView {
                    imageSource: "images/teaser.png"
                    preferredWidth: _screenSize.width
                    preferredHeight: _screenSize.height
                }
            }
        }
    }
    actions: [
        InvokeActionItem {
            title: qsTr("Rate it!")
            imageSource: "asset:///icons/ic_rateit.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            query{
                invokeTargetId: "sys.appworld"
                invokeActionId: "bb.action.OPEN"
                uri: "appworld://content/26166877"                
            }
        }
    ]
}
