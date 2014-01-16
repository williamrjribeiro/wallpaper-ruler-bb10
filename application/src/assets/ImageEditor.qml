import bb.cascades 1.0

Container {
    property alias imageTrackerSource: imt_tracker.imageSource
    property alias imageView: iv_image
    
    background: Color.create("#ffe845bc")
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    implicitLayoutAnimationsEnabled: false
    // The top-level container uses a dock layout so that the image can
    // always remain centered on the screen as it changes size
    layout: DockLayout {
    }
    signal imageReady()
    function resetEdits(){
        console.log("[ImageEditor.resetEdits]");
        iv_image.scaleX = 1.0;
        iv_image.scaleY = 1.0;
        iv_image.translationX = 0.0;
        iv_image.translationY = 0.0;
        iv_image.rotationZ = 0.0;
        iv_image.initialRotationZ = 0.0;
        iv_image.initialWindowX = 0.0;
        iv_image.initialWindowY = 0.0;
        iv_image.initialScale = 1.0;
        // Must reset the ImageView and the ImageTracker or else if the user selecs the same file again
        // it won't be loaded
        iv_image.resetImage();
        imt_tracker.imageSource = "";
    
    }
    function wallpapperFit(){
        var ratio = 1.0;
        
        // Calculate the correct scale based on the loaded image!
        if(imt_tracker.width > imt_tracker.height) {
            ratio = (imt_tracker.width / imt_tracker.height).toFixed(3);
        }
        else {
            ratio = (imt_tracker.height / imt_tracker.width).toFixed(3);
        }
        
        iv_image.scaleX = ratio;
        iv_image.scaleY = ratio;
        iv_image.initialScale = ratio;
        
        console.log("[ImageEditor.wallpapperFit] imt_tracker.width: " + imt_tracker.width
        +", imt_tracker.height: " + imt_tracker.height
        + ", ratio: " + ratio);
        
        imageReady();
    }
    ImageView {
        id: iv_image
        scalingMethod: ScalingMethod.AspectFit	// The wallpaperFit() only works with this scalingMethod
        loadEffect: ImageViewLoadEffect.None
        minHeight: _screenSize.height			// The wallpaper image is always a square with the biggest device size
        minWidth: _screenSize.height
        horizontalAlignment: HorizontalAlignment.Center // The image is initially centered on the container
        verticalAlignment: VerticalAlignment.Center
        
        // Flag to prevent a drag gesture from starting during pinch
        property bool pinchHappening: false
        
        // The scale of the image when a pinch gesture begins
        property double initialScale: 1.0
        
        // How fast the image grows/shrinks in response to the pinch gesture
        property double scaleFactor: 1.25
        
        // The minimal scale the image can get (minimal contraction)
        property double minimalScale: 0.25
        
        // The maximal scale the image can get (max expansion)
        property double maxScale: 10.0
        
        // The rotation of the image when a pinch gesture begins
        property double initialRotationZ: 0.0
        
        // How fast the image rotates in response to the pinch gesture
        property double rotationFactor: 1.0
        
        // Flag to prevent dragging when a pinch ends but the two fingers are
        // not taken off the screen simultaneously
        property bool dragHappening: false
        
        // The position of the image when a drag gesture begins
        property double initialWindowX: 0.0
        property double initialWindowY: 0.0
        
        // How fast the image moves in response to the drag gesture
        property double dragFactor: 1.25
        
        // the minimal touch movement needed in order to make changes 
        property double minimalMovement: 1.0
        
        property bool canMoveX: false
        property bool canMoveY: false
        
        attachedObjects: [
            ImageTracker {
                id: imt_tracker
                onStateChanged: {
                    //console.log("[ImageEditor.iv_image.imt_tracker] state: " + state);
                    if (state == ResourceState.Loaded){
                        // BB10 supposelly has some problems of images that are bigger than 2048x2048 px...
                        iv_image.image = imt_tracker.image;
                        wallpapperFit();
                    }
                }
            }
        ]
        implicitLayoutAnimationsEnabled: false
    } // end of ImageView
    // Drag gesture
    onTouch: {
        // Determine the location inside the image that was touched, relative to the container, and move it accordingly
        if (iv_image.pinchHappening) {
            // A pinch was started by touching the image with a second finger so interrupt any ongoing drag gesture
            iv_image.dragHappening = false
        } else {
            if (event.isDown()) {
                // Start a dragging gesture
                // iv_image.dragHappening = true;
                iv_image.initialWindowX = event.windowX;
                iv_image.initialWindowY = event.windowY;
            //} else if (iv_image.dragHappening && event.isMove()) {
            } else if (event.isMove()) {
                
                var  tx = (event.windowX - iv_image.initialWindowX)
                	,ty = (event.windowY - iv_image.initialWindowY);
                	
                    //console.log("[ImageEditor.iv_image.onTouch.move] tx: " + tx+", ty: "+ty+", abs(tx): "+Math.abs(tx));
                
                // Move the image and record its new position ONLY if moved more than 2xdragFactor
                if(!iv_image.canMoveX){
                    iv_image.initialWindowX = event.windowX;
                    iv_image.canMoveX = Math.abs(tx) > iv_image.minimalMovement;
                }
                else{
                    iv_image.dragHappening = true;
                    iv_image.translationX += tx * iv_image.dragFactor
                    iv_image.initialWindowX = event.windowX
                }
                
                if(!iv_image.canMoveY){
                    iv_image.initialWindowY = event.windowY;
                    iv_image.canMoveY = Math.abs(ty) > iv_image.minimalMovement
                }
                else{
                    iv_image.dragHappening = true;
                    iv_image.translationY += ty * iv_image.dragFactor
                    iv_image.initialWindowY = event.windowY
                }
                
                //console.log("[ImageEditor.iv_image.onTouch.move] translationX: " + iv_image.translationX+", translationY: "+iv_image.translationY);
            } else {
                // Event type is Up or Cancel: interrupt any ongoing drag gesture
                iv_image.dragHappening = false;
                iv_image.pinchHappening = false;
                iv_image.canMoveX = false; 
                iv_image.canMoveY = false;
                console.log("[ImageEditor.iv_image.onTouch.move] translationX: " + iv_image.translationX+", translationY: "+iv_image.translationY);
            }
        }
    }
    gestureHandlers: [
        // Add a handler for pinch gestures
        PinchHandler {
            onPinchStarted: {
                // Save the initial scale and rotation of the image
                iv_image.initialScale = iv_image.scaleX
                iv_image.initialRotationZ = iv_image.rotationZ
                // Prevent a drag gesture from starting during pinch
                iv_image.pinchHappening = true
            }
            onPinchUpdated: {
                //console.log("[ImageEditor.iv_image.PinchHandler.onPinchUpdated] pinchRatio: " + event.pinchRatio + ", distance: "+event.distance);
                                
                // Calculate the new scale (expanding or contracting)
                var s = iv_image.initialScale + ((event.pinchRatio - 1) * iv_image.scaleFactor);
                
                // Don't let the user scale down the image too much or else the pinch get's reversed
                if(s < iv_image.minimalScale) 
                    s = iv_image.minimalScale;
                else if(s > iv_image.maxScale) 
                    s = iv_image.maxScale;
                	
                iv_image.scaleX = s;
                iv_image.scaleY = s;
                
                // Calculate and apply the new rotation
                iv_image.rotationZ = iv_image.initialRotationZ + (event.rotation * iv_image.rotationFactor);
                //iv_image.rotationZ += event.rotation * iv_image.rotationFactor;
                console.log("[ImageEditor.iv_image.PinchHandler.onPinchUpdated] iv_image.rotationZ:",iv_image.rotationZ,"e.rotation:",event.rotation);
            }
            onPinchEnded: {
                // Allow a drag gesture to begin
                iv_image.pinchHappening = false;
                
                // increase the scale factor when image is too large so that pinch is more effective
                if(iv_image.scaleX >= 4.0)
                    iv_image.scaleFactor = 6.0;
                else if(iv_image.scaleX < 4.0 && iv_image.scaleX >= 2.5)
                    iv_image.scaleFactor = 3.75;
                else if(iv_image.scaleX < 2.5 && iv_image.scaleX >= 1.75)
                    iv_image.scaleFactor = 2.5;
                else 
                    iv_image.scaleFactor = 1.25;
                    
                console.log("[ImageEditor.iv_image.PinchHandler.onPinchEnded] scaleX: " + iv_image.scaleX+", scaleY: " + iv_image.scaleY+", rotationZ: "+iv_image.rotationZ);
            }
        }
    ]
} // end of Container