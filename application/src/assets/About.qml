import bb.cascades 1.0

Page {
    Container {
        layout: StackLayout {

        }
        topMargin: 40.0
        leftPadding: 55.0
        rightPadding: 55.0
        ImageView {
            imageSource: "asset:///icons/ic_bbm.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: 190.0
            preferredHeight: 190.0
        }
        Label {
            text: qsTr("Creators")
            textStyle.fontSize: FontSize.XXLarge
        }
        ListView {
            id: creatorsList
            dataModel: XmlDataModel {
                source: "data/creators.xml"
            }
            listItemComponents: [
                ListItemComponent {
                    type: "creator"
                    Container {
                        id: lisRoot
                        bottomMargin: 30.0
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        ImageView {
                            imageSource: "asset:///icons/" + ListItemData.img
                            preferredHeight: 0.0
                            preferredWidth: 0.0
                            minWidth: 165.0
                            minHeight: 165.0
                        }
                        Container {
                            layout: StackLayout {}
                            Label {
                                text: ListItemData.name
                                textFormat: TextFormat.Plain
                                textStyle.fontSize: FontSize.Small
                                textStyle.fontWeight: FontWeight.Bold
                            }
                            Label {
                                text: ListItemData.info
                                textFormat: TextFormat.Plain
                                multiline: true
                                textStyle.fontSize: FontSize.XXSmall
                            }
                            Label {
                                text: ListItemData.link
                                textFormat: TextFormat.Plain
                                textStyle.fontSize: FontSize.Small
                            }
                        }
                    }
                }
            ]
        }
    }
}
