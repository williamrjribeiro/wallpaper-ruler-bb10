// We use the Camera control from cascades multimedia, it needs to be initiated from C++ code before we can use it though.
import bb.cascades 1.0
import bb.cascades.multimedia 1.0
import bb.multimedia 1.0

Page {
    id: cameraRootPage
    actionBarVisibility: ChromeVisibility.Hidden
    function shutDownCamera() {
        console.log("[CustomCamera.shutDownCamera] camera.isOpen: " + camera.isOpen);
        
        if (camera.isOpen) {
        	camera.close();
        }
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        onTouch: {
            console.log("[CustomCamera.onTouch] event.isUp: " + event.isUp() + ", event.isDown: " + event.isDown() + ", event.isMove: " + event.isMove());

            // Only deal with Touch Event once they are over
            if (event.isUp()) {
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
                CameraSettings {
                    id: cameraSettings
                },
                SystemSound {
                    id: cameraSound
                    sound: SystemSound.CameraShutterEvent
                }
            ]
        } // end of Camera

        contextActions: [
            ActionSet {
                title: "Frames & Camera Options"
                subtitle: "To help you take the perfect picture for your wallpaper"
                ActionItem {
                    id: homeScreenFrame
                    title: "Home Frame"
                    onTriggered: {
                        console.log("[CustomCamera.homeScreenFrame.onTriggered]");
                    }
                }
                ActionItem {
                    id: lockedScreenFrame
                    title: "Locked Frame"
                    onTriggered: {
                        console.log("[CustomCamera.lockedScreenFrame.onTriggered]");
                    }
                }
                ActionItem {
                    id: switchCamera
                    title: "Switch Cameras"
                    onTriggered: {
                        console.log("[CustomCamera.switchCamera.onTriggered]");
                        camera.close();
                        camera.isHear = !camera.isHear;
                    }
                }
            } // end of ActionSet
        ] // end of contextActions list

        contextMenuHandler: ContextMenuHandler {
            id: contextMenuHandler
            onVisualStateChanged: {
                if (ContextMenuVisualState.VisibleCompact == contextMenuHandler.visualState) {
                    hideSomethingInMyUi();
                } else if (ContextMenuVisualState.Hidden == contextMenuHandler.visualState) {
                    showSomethingInMyUi();
                }
            }
        }
    }
}
