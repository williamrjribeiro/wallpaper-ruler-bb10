// We use the Camera control from cascades multimedia, it needs to be initiated from C++ code before we can use it though.
import bb.cascades 1.0
import bb.cascades.multimedia 1.0
import bb.multimedia 1.0

// It's better to work with JavaScript Object in separate js files. http://harmattan-dev.nokia.com/docs/library/html/qt4/qml-variant.html 
import "js/togglebuttonmanager.js" as ToggleButtonManager;

Page {
    id: cameraRootPage
    property alias tutorial: iv_tutorialFrame
    actionBarVisibility: ChromeVisibility.Hidden
    function shutDownCamera() {
        console.log("[CustomCamera.shutDownCamera] camera.isOpen: " + camera.isOpen);
        if (camera.isOpen) {
        	camera.close();
        }
        container.pinchHappening = false;
    }
    onCreationCompleted: {
        console.log("[CustomCamera.mfeRootPage.onCreationCompleted]");
        ToggleButtonManager.initToggleButtons([ai_homeFrame,ai_lockedFrame,ai_activeFrame]);
    }
    function showFrame(show,filePath){
        console.log("[CustomCamera.showFrame] show: "+show+", filePath: "+filePath);
        switch(filePath){
            case "asset:///frames/fr_home.png":
                iv_homeFrame.opacity = show ? 1.0 : 0.0;
                iv_activeFrame.opacity = 0.0;
                iv_lockedFrame.opacity = 0.0;
                break;
            case "asset:///frames/fr_active.png":
                iv_homeFrame.opacity = 0.0;
                iv_activeFrame.opacity = show ? 1.0 : 0.0;
                iv_lockedFrame.opacity = 0.0;
                break;
            case "asset:///frames/fr_locked.png":
                iv_homeFrame.opacity = 0.0;
                iv_activeFrame.opacity = 0.0;
                iv_lockedFrame.opacity = show ? 1.0 : 0.0;
                break;
        }
    }
    Container {
        id: container
        // Flag to prevent a drag gesture from starting during pinch
        property bool pinchHappening: false
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        onTouch: {
            console.log("[CustomCamera.onTouch] event.isUp: " + event.isUp() + ", event.isDown: " + event.isDown() + ", event.isMove: " + event.isMove());

            // Only deal with Touch Event once they are over. If it's pinching ignore everything!
            if ( !pinchHappening && event.isUp()) {
                
                // Hide the tutorial image
                if(iv_tutorialFrame.visible){
                    trans_fadeOut.play();
                }
                
                // Open the Front or Rear camera if it's not yet.
                if (! camera.isOpen) {
                    camera.open( camera.isHear ? CameraUnit.Rear : CameraUnit.Front);
                } 
                // Take photo only if the context menu is hidden
                else if ( ContextMenuVisualState.Hidden == contextMenuHandler.visualState ){
                    camera.capturePhoto();
                }
            }
        }

        gestureHandlers: [
            // Add a handler for pinch gestures
            PinchHandler {
                onPinchStarted: {
                    // Prevent a drag gesture from starting during pinch
                    container.pinchHappening = true;
                }
                onPinchUpdated: {
                    console.log("[CustomCamera.onPinchUpdated]pinchRatio: " + event.pinchRatio +" distance:" + event.distance);
                    
                    _cameraManager.setCameraZoomByPinchRatio(camera, event.pinchRatio);
                }
                onPinchEnded: {
                    console.log("[CustomCamera.onPinchEnded]");
                    // Allow a drag gesture to begin
                    container.pinchHappening = false;
                }
            }
        ]

        // This is the camera control that is defined in the cascades multimedia library.
        Camera {
            id: camera
            property bool isOpen: false
            property bool isHear: true

            // When the camera is opened we want to start the viewfinder
            onCameraOpened: {
                
                isOpen = true;
                
                // Using helper function to set resolution: 9/16
                _cameraManager.selectAspectRatio(camera, 1);

                // Additional camera settings, setting focus mode and stabilization
                camera.startViewfinder();
            }

            // There are loads of messages we could listen to here.
            // onPhotoSaved and onShutterFired are taken care of in the C++ code.
            onCameraOpenFailed: {
                console.log("[CustomCamera.onCameraOpenFailed] error " + error);
            }
            onViewfinderStartFailed: {
                console.log("[CustomCamera.onViewfinderStartFailed] error " + error);
                isOpen = false;
            }
            onViewfinderStopFailed: {
                console.log("[CustomCamera.onViewfinderStopFailed] error " + error);
            }
            onPhotoCaptureFailed: {
                console.log("[CustomCamera.onPhotoCaptureFailed] error " + error);
            }
            onPhotoSaveFailed: {
                console.log("[CustomCamera.onPhotoSaveFailed] error " + error);
            }
            onPhotoSaved: {
                _cameraManager.capturedImage = fileName;

				// re-load the datamodel to show the recent captured image
                _imageGridDataProvider.loadDataModel();
            }
            onShutterFired: {
                // A cool trick here to play a sound. There are legal requirements in many countries to have a shutter-sound when
                // taking pictures. So we need this shutter sound if you are planning to submit you're app to app world.
                // So we play the shutter-fire sound when the onShutterFired event occurs.
                cameraSound.play();
            }
            onCameraResourceAvailable: {
                // This signal handler is triggered when the Camera resource becomes available to app
                // after being lost by for example putting the phone to sleep, once it has been received
                // it is possible to start the viewfinder again.
                camera.startViewfinder()
            }
            onCameraClosed: {
                isOpen = false;
            }
            onCameraCloseFailed: {
                console.log("[CustomCamera.onCameraCloseFailed] error " + error);
                // try again
                camera.close();
            }
            attachedObjects: [
                SystemSound {
                    id: cameraSound
                    sound: SystemSound.CameraShutterEvent
                }
            ]
            visible: false
        } // end of Camera

        contextActions: [
            ActionSet {
                title: "Frames & Camera Options"
                subtitle: "To help you take the perfect picture for your wallpaper"
                ActionItem {
                    id: ai_switchCamera
                    title: "Switch Cameras"
                    onTriggered: {
                        console.log("[CustomCamera.ai_switchCamera.onTriggered]");
                        camera.close();
                        camera.isHear = !camera.isHear;
                    }
                }
                ActionItem {
                    id: ai_homeFrame
                    objectName: "homeFrameToggle"
                    title: qsTr("Home Screen")
                    imageSource: "asset:///icons/ic_home_screen.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_homeFrame),"asset:///frames/fr_home.png");
                    }
                }
                ActionItem {
                    id: ai_lockedFrame
                    objectName: "lockedFrameToggle"
                    title: qsTr("Locked Screen")
                    imageSource: "asset:///icons/ic_unlocked.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_lockedFrame),"asset:///frames/fr_active.png");
                    }
                }
                ActionItem {
                    id: ai_activeFrame
                    objectName: "activeFrameToggle"
                    title: qsTr("Active Frame")
                    imageSource: "asset:///icons/ic_active_screen.png"
                    onTriggered: {
                        showFrame(ToggleButtonManager.handleToggle(ai_activeFrame),"asset:///frames/fr_locked.png");
                    }
                }
            } // end of ActionSet
        ] // end of contextActions list

        contextMenuHandler: ContextMenuHandler {
            id: contextMenuHandler
            onVisualStateChanged: {
                if (ContextMenuVisualState.VisibleCompact == contextMenuHandler.visualState) {
                    //hideSomethingInMyUi();
                } else if (ContextMenuVisualState.Hidden == contextMenuHandler.visualState) {
                    //showSomethingInMyUi();
                }
            }
        }
        layout: AbsoluteLayout {
        }
        ImageView {
            id: iv_homeFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_home.png"
        }
        
        ImageView {
            id: iv_activeFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_active.png"
        }
        
        ImageView {
            id: iv_lockedFrame
            opacity: 0.0
            scalingMethod: ScalingMethod.None
            touchPropagationMode: TouchPropagationMode.None // ignore all touch events so the ImageEditor can be interactive
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_locked.png"
        }
        
        ImageView {
            id: iv_tutorialFrame
            opacity: 1.0
            scalingMethod: ScalingMethod.None
            loadEffect: ImageViewLoadEffect.None
            imageSource: "asset:///frames/fr_long_press.png"
            animations: [
                FadeTransition {
                    id: trans_fadeOut
                    fromOpacity: 1.0
                    toOpacity: 0.0
                    onEnded: {
                        // the tutorial image will remain invisible even after the user leaves the MFE.
                        iv_tutorialFrame.visible = false;
                    }
                }
            ]
        }
    }
}
