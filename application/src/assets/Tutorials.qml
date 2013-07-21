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
            text: qsTr("Tutorials")
            textStyle.fontSize: FontSize.XXLarge
        }
        ScrollView {
            content: Container {
		        Label {
		            text: "A navigation control that allows the user to switch between tabs.

The tabs can be used to either completely replace displayed content by setting new panes or to filter existing content in a single pane based on which tab is currently selected.

The Tab objects in the TabbedPane are added to the Action bar, which is a horizontal bar displayed at the bottom of the screen. The tabs on the Action bar can be pressed to switch to display their content. The Tab objects take an AbstractPane as their content. If the content is not 0, it will be displayed in the TabbedPane when the corresponding tab is selected.

If the TabbedPane has only one Tab and the content of that Tab has no actions, the Action bar is not displayed since there aren't any additional tabs or actions to be displayed.

The first added Tab becomes the active one.

If the content of the Tab that is being displayed has any ActionItem objects associated with it, these actions take priority and are placed on the Action bar, while the other tabs are pushed to the side bar. This behavior can be changed by setting the showTabsOnActionBar property to true. If showTabsOnActionBar is true, tabs will be placed on the Action bar and actions will be placed in the Action menu.

The user can access tabs or actions that are not present on the Action bar by pressing the overflow tab, which is automatically added to the Action bar when it is needed.

If a tab is selected that is not currently present on the Action bar, the side bar will then change to the active-tab state and show the title and image of that tab along with an overflow symbol.

It is possible for the application to programmatically change the appearance of the sidebar by setting the property sidebarState.

A tab can display a visual notification image if there is new content available. If any tab that is only shown in the side bar contains such a visual notification, the overflow tab will also display such a visual notification. This visual notification will remain on the overflow tab until the corresponding tab(s) have been displayed (e.g. by opening the side bar) or the visual notification is removed from all tabs that are only visible in the side bar and that had new content.

Here's an example of a TabbedPane with three tabs, each with its own page and set of actions. The tabs are set to show on the Action bar so that the actions get pushed to the Action menu."
		            multiline: true
                    textFormat: TextFormat.Plain
		            textStyle.fontSize: FontSize.XSmall
                    textStyle.textAlign: TextAlign.Left
                }
		    }
            scrollViewProperties.pinchToZoomEnabled: false
            scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.Default
            scrollViewProperties.scrollMode: ScrollMode.Vertical
            enabled: true
        }
    }
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Back"
            onTriggered: { aboutNavigationPane.pop(); }
        }
    }
}
