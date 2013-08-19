import bb.cascades 1.0

Page {
    property alias creators: cdl_creators
    ControlDelegate {
        id: cdl_creators
        delegateActive: false;
        sourceComponent: cdf_creatorsList
    }
    attachedObjects: [
        ComponentDefinition {
            id: cdf_creatorsList
            ScrollView {
                scrollViewProperties.scrollMode: ScrollMode.Horizontal
                scrollViewProperties.initialScalingMethod: ScalingMethod.None
                scrollViewProperties.pinchToZoomEnabled: false
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        imageSource: "images/creators_1.jpg"
                    }
                    ImageView {
                        imageSource: "images/creators_1.jpg"
                    }
                    ImageView {
                        imageSource: "images/creators_1.jpg"
                    }
                    ImageView {
                        imageSource: "images/creators_1.jpg"
                    }
                }
            }
        }
    ]
}
