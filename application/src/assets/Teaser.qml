import bb.cascades 1.0

Page {
    property alias delegate: cdl_teaser
    
    ControlDelegate {
        id: cdl_teaser
        delegateActive: false;
        sourceComponent: ComponentDefinition {
            id: cpd_teaser
            Container {
                id: ctn_teaser
                preferredWidth: _screenSize.width
                preferredHeight: _screenSize.height
                background: Color.Black
                layout: DockLayout {}
                topPadding: 20.0
                leftPadding: 20.0
                rightPadding: 20.0
                //bottomPadding: 120.0
                property alias fadeIn: wappyFadeIn;
                onTouch: {
                    if(event.isUp()){
                        wappyFadeIn.play();
                    }
                }
                Container {
                    id: ctn_stars
                    horizontalAlignment: HorizontalAlignment.Fill
                    leftPadding: 120.0
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        id: imv_start1
                        imageSource: "images/star.png"
                        opacity: 0.0
                        animations: [
                            ParallelAnimation {
                                id: starSlideIn1
                                delay: 60
                                FadeTransition {
                                    fromOpacity: 0.0
                                    toOpacity: 1.0
                                    duration: 500
                                }
                                TranslateTransition {
                                    fromX: - _screenSize.width
                                    toX: 0.0
                                    easingCurve: StockCurve.BounceOut
                                    duration: 1000
                                }
                            }
                        ]
                    }
                    ImageView {
                        id: imv_start2
                        imageSource: "images/star.png"
                        opacity: 0.0
                        animations: [
                            ParallelAnimation {
                                id: starSlideIn2
                                delay: 50
                                FadeTransition {
                                    fromOpacity: 0.0
                                    toOpacity: 1.0
                                    duration: 500
                                }
	                            TranslateTransition {
	                                fromX: - _screenSize.width
	                                toX: 0.0
	                                easingCurve: StockCurve.BounceOut
	                                duration: 1000
	                            }
	                        }
                        ]
                    }
                    ImageView {
                        id: imv_start3
                        imageSource: "images/star.png"
                        opacity: 0.0
                        animations: [
                            ParallelAnimation {
                                id: starSlideIn3
                                delay: 40 
                                FadeTransition {
                                    fromOpacity: 0.0
                                    toOpacity: 1.0
                                    duration: 500
                                }
	                            TranslateTransition {
	                                fromX: - _screenSize.width
	                                toX: 0.0
	                                easingCurve: StockCurve.BounceOut
	                                duration: 1000
	                            }
	                        }
                        ]
                    }
                    ImageView {
                        id: imv_start4
                        imageSource: "images/star.png"
                        opacity: 0.0
                        animations: [
                            ParallelAnimation {
                                id: starSlideIn4
                                delay: 30
                                FadeTransition {
                                    fromOpacity: 0.0
                                    toOpacity: 1.0
                                    duration: 500
                                }
	                            TranslateTransition {
	                                fromX: - _screenSize.width
	                                toX: 0.0
	                                easingCurve: StockCurve.BounceOut
	                                duration: 1000
	                            }
	                        }
                        ]
                    }
                    ImageView {
                        id: imv_start5
                        imageSource: "images/star.png"
                        opacity: 0.0
                        animations: [
                            ParallelAnimation {
                                id: starSlideIn5
                                delay: 0
                                FadeTransition {
                                    fromOpacity: 0.0
                                    toOpacity: 1.0
                                    duration: 500
                                }
	                            TranslateTransition {
	                                fromX: - _screenSize.width
	                                toX: 0.0
	                                easingCurve: StockCurve.BounceOut
	                                duration: 1000
	                            }
	                        }
                        ]
                    }
                } // End of ctn_stars
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Center
                    bottomPadding: 140.0
                    clipContentToBounds: false
                    Label {
                        text: qsTr("Wappy Camera is a new feature that works with the device's cameras. To implement it we need your support. Give us a 5 star rating and ask for it on the comments.\nThanks!")
                        multiline: true
                        verticalAlignment: VerticalAlignment.Center
                        textStyle.color: Color.White
                        autoSize.maxLineCount: 6
                        textStyle.fontSize: _screenSize.height == 720.0 ? FontSize.Default : FontSize.Large
                        textStyle.textAlign: TextAlign.Center
                    }
                }
                ImageView {
                    id: imv_wappy
                    imageSource: "images/wappy.png"
                    opacity: 0.0
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Bottom
                }
                animations: [
                    FadeTransition {
                        id: wappyFadeIn
                        target: imv_wappy
                        fromOpacity: 0.0
                        toOpacity: 1.0
                        duration: 1000
                        delay: 500
                        onEnded: {
                            starSlideIn1.play();
                            starSlideIn2.play();
                            starSlideIn3.play();
                            starSlideIn4.play();
                            starSlideIn5.play();
                        }
                    }
                ]
                onCreationCompleted: {
                    console.log("[Teaser.cdl_teaser.ctn_teaser.onCreationCompleted]");
                    wappyFadeIn.play();
                }
            } // Teaser Container  End
        }
    } // End of cdl_teaser
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
