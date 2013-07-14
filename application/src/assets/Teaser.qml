import bb.cascades 1.0

Page {
    Container {
        leftPadding: 50;
        rightPadding: 50;
        layout: DockLayout {

        }
        Label {
            text: qsTr("Wappy Camera is an awesome feature that we want to implement but we need some love. Please give us a 5 star rating on BlackBerry World and ask for the Wappy Camera. Thanks!")
            multiline: true
            autoSize.maxLineCount: 10
            textFormat: TextFormat.Plain
            enabled: false
            textStyle.fontStyle: FontStyle.Default
            textStyle.fontWeight: FontWeight.Default
            textStyle.fontSize: FontSize.XLarge
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.textAlign: TextAlign.Justify

        }
    }
    actions: [
        InvokeActionItem {
            title: qsTr("Rate it!")
            imageSource: "asset:///icons/ic_share.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            query{
                invokeTargetId: "sys.appworld"
                invokeActionId: "bb.action.OPEN"
                uri: "appworld://content/26166877"                
            }
        }
    ]
}
