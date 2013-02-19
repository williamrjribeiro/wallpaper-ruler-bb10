import bb.cascades 1.0

NavigationPane {
    id: aboutNavigationPane
    Page {
        Container {
            Logo {
            }
            Label {
                text: "This is the About Us tab"
            }
        }
        actions: [
            ActionItem {
                title: "Tutorial"
                onTriggered: {
                    var page = pageDefinition.createObject();
                    aboutNavigationPane.push(page);
                }
            },
            ActionItem {
                title: "Creators"
                onTriggered: {
                    var page = pageDefinition.createObject();
                    aboutNavigationPane.push(page);
                }
            },
            ActionItem {
                title: "Changelog"
            }
        ]
        attachedObjects: [
            ComponentDefinition {
                id: pageDefinition;
                source: "Tutorials.qml"
            }
        ]
    }
    onPopTransitionEnded: { page.destroy(); }
}
