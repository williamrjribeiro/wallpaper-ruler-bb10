import bb.cascades 1.0

Page {
    Container {
        Label {
            text: "Welcome to the Tutorials section!"
        }
    }
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Back"
            onTriggered: { aboutNavigationPane.pop(); }
        }
    }
}
