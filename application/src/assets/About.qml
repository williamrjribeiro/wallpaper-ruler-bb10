import bb.cascades 1.0

Page {
    property alias creators: cdl_creators
    actionBarVisibility: _screenSize.height == _screenSize.width ? ChromeVisibility.Hidden : ChromeVisibility.Visible
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
                    Container {
                        layout: DockLayout {}
                        ImageView {
                            // Will
                            imageSource: "images/creators_1.jpg"
                            minWidth: _screenSize.width
                            minHeight: _screenSize.height
                        }
                        TextArea {
                            text: "
Originally from Brasília, Brazil. 

Original creator of the BlackBerry® PlayBook™ application Wallpaper Ruler and leader of the project. Responsible for managing the project and the team, writing software specification, UX guidelines, programming, release management"
                            editable: false
                            focusHighlightEnabled: false
                            enabled: false
                            preferredWidth: _screenSize.width
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            inputMode: TextAreaInputMode.Default
                            textFormat: TextFormat.Plain
                            backgroundVisible: false
                            scrollMode: TextAreaScrollMode.Elastic
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontWeight: FontWeight.Normal
                            textStyle.fontSize: FontSize.Small
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Bottom
                            maxWidth: 468
                            horizontalAlignment: HorizontalAlignment.Center
                            bottomPadding: _screenSize.height == _screenSize.width ? 0 : 140.0
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Button {
                                opacity: 0.02
                                // will auto-invoke after re-arming
                                onClicked: linkInvocation.query.uri = "http://www.facebook.com/billbsb"
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://www.twitter.com/bill_bsb"
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://instagram.com/billbsb";
                            }
                        }
                    }
                    Container {
                        layout: DockLayout {}
                        ImageView {
                            // Di
                            imageSource: "images/creators_2.jpg"
                            minWidth: _screenSize.width
                            minHeight: _screenSize.height
                        }
                        TextArea {
                            text: "
Originally from Coimbra, Portugal.
                            
Responsible for making sure the application is bug free, matches the specs and is usable. Later in the project also managing the project and the team. She was the inspiration for the version 1.0 of the application."
                            editable: false
                            focusHighlightEnabled: false
                            enabled: false
                            preferredWidth: _screenSize.width
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            inputMode: TextAreaInputMode.Default
                            textFormat: TextFormat.Plain
                            backgroundVisible: false
                            scrollMode: TextAreaScrollMode.Elastic
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontWeight: FontWeight.Normal
                            textStyle.fontSize: FontSize.Small
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Bottom
                            maxWidth: 468
                            horizontalAlignment: HorizontalAlignment.Center
                            bottomPadding: _screenSize.height == _screenSize.width ? 0 : 140.0
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Button {
                                opacity: 0.02
                                // will auto-invoke after re-arming
                                onClicked: linkInvocation.query.uri = "http://www.facebook.com/billbsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://www.twitter.com/bill_bsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://instagram.com/billbsb";
                            }
                        }
                    }
                    Container {
                        layout: DockLayout {}
                        ImageView {
                            // Ponyo
                            imageSource: "images/creators_3.jpg"
                            minWidth: _screenSize.width
                            minHeight: _screenSize.height
                        }
                        TextArea {
                            text: "Originally from Ouarzazate, Morocco.
                            
Responsible for the usability, experience, typography, and other visual elements."
                            editable: false
                            focusHighlightEnabled: false
                            enabled: false
                            preferredWidth: _screenSize.width
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            inputMode: TextAreaInputMode.Default
                            textFormat: TextFormat.Plain
                            backgroundVisible: false
                            scrollMode: TextAreaScrollMode.Elastic
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontWeight: FontWeight.Normal
                            textStyle.fontSize: FontSize.Small
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Bottom
                            maxWidth: 468
                            horizontalAlignment: HorizontalAlignment.Center
                            bottomPadding: _screenSize.height == _screenSize.width ? 0 : 140.0
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Button {
                                opacity: 0.02
                                // will auto-invoke after re-arming
                                onClicked: linkInvocation.query.uri = "http://www.facebook.com/billbsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://www.twitter.com/bill_bsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://instagram.com/billbsb";
                            }
                        }
                    }
                    Container {
                        layout: DockLayout {}
                        ImageView {
                            // Marco
                            imageSource: "images/creators_4.jpg"
                            minWidth: _screenSize.width
                            minHeight: _screenSize.height
                        }TextArea {
                            text: "Originally from Sicily, Italy. 
                            
Responsible for software architecture, testing and programming."
                            editable: false
                            focusHighlightEnabled: false
                            enabled: false
                            preferredWidth: _screenSize.width
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            inputMode: TextAreaInputMode.Default
                            textFormat: TextFormat.Plain
                            backgroundVisible: false
                            scrollMode: TextAreaScrollMode.Elastic
                            textStyle.textAlign: TextAlign.Left
                            textStyle.fontWeight: FontWeight.Normal
                            textStyle.fontSize: FontSize.Small
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Bottom
                            maxWidth: 468
                            horizontalAlignment: HorizontalAlignment.Center
                            bottomPadding: _screenSize.height == _screenSize.width ? 0 : 140.0
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Button {
                                opacity: 0.02
                                // will auto-invoke after re-arming
                                onClicked: linkInvocation.query.uri = "http://www.facebook.com/billbsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://www.twitter.com/bill_bsb";                       
                            }
                            Button {
                                opacity: 0.02
                                onClicked: linkInvocation.query.uri = "http://instagram.com/billbsb";
                            }
                        }
                    }
                }
                attachedObjects: [
                    Invocation {
                        id: linkInvocation
                        property bool auto_trigger: false
                        query {
                            uri: "http://www.google.com"
                            onUriChanged: linkInvocation.query.updateQuery();
                        }
                        onArmed: {
                            // don't auto-trigger on initial setup
                            if (auto_trigger)
                                trigger("bb.action.OPEN");
                            auto_trigger = true;    // allow re-arming to auto-trigger
                        }
                    }
                ]
            } // End of ScrollView
        } // End of ComponentDefinition
    ]
}
