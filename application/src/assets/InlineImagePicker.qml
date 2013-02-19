import bb.cascades 1.0

Container {
    ListView {
        layout: GridListLayout {}
        dataModel: XmlDataModel {
            source: "flatmodel.xml"
        }
        
        listItemComponents: [
            ListItemComponent {
                type: "image"
                
                ImageView {
                    imageSource: ListItemData
                    scalingMethod: ScalingMethod.AspectFill
                }
            }
        ]
    }
}
