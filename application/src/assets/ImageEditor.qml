import bb.cascades 1.0

Container {
    // The top-level container uses a dock layout so that the image can
    // always remain centered on the screen as it changes size
    layout: DockLayout {
    }
    property alias image: imageTracker
    property alias myImageElement: iv_image
    background: Color.Yellow
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    implicitLayoutAnimationsEnabled: false
    signal imageReady()
    function resetEdits(){
        console.log("[ImageEditor.resetEdits]");
        iv_image.scaleX = 1.0;
        iv_image.scaleY = 1.0;
        iv_image.translationX = 0.0;
        iv_image.translationY = 0.0;
        iv_image.rotationZ = 0.0;
        
        // Must reset the ImageView and the ImageTracker or else if the user selecs the same file
        // it won't be loaded
        iv_image.resetImage();
        imageTracker.imageSource = "";
    
    }
    function mabs(val){
        return (val ^ (val >> 31)) - (val >> 31);
    }
    function wallpapperFit(){
        var ratio = 1.0;
        
        // Calculate the correct scale based on the loaded image!
        if(imageTracker.width > imageTracker.height)
            ratio = imageTracker.width / imageTracker.height;
        else if(imageTracker.width < imageTracker.height)
            ratio = imageTracker.height / imageTracker.width;
        
        iv_image.scaleX = ratio;
        iv_image.scaleY = ratio;
        iv_image.wallpaperRatio = ratio;
        
        console.log("[ImageEditor.wallpapperFit] imageTracker.width: " + imageTracker.width
        +", imageTracker.height: " + imageTracker.height
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
        
        // The scale of the image when used as the device wallpaper - set on wallpaperFit()
        property double wallpaperRatio: 0.0
        
        // How fast the image grows/shrinks in response to the pinch gesture
        property double scaleFactor: 1.25
        
        // The rotation of the image when a pinch gesture begins
        property double initialRotationZ: 0.0
        
        // How fast the image rotates in response to the pinch gesture
        property double rotationFactor: 1.0
        
        // Flag to prevent dragging when a pinch ends but the two fingers are
        // not taken off the screen simultaneously
        property bool dragHappening: false
        
        // The position of the image when a drag gesture begins
        property double initialWindowX
        property double initialWindowY
        
        // How fast the image moves in response to the drag gesture
        property double dragFactor: 1.25
        
        // the minimal touch movement needed in order to make changes 
        property double minimalMovement: 3.0
        
        property bool canMoveX: false
        property bool canMoveY: false
        
        attachedObjects: [
            ImageTracker {
                id: imageTracker
                onStateChanged: {
                    //console.log("[ImageEditor.iv_image.imageTracker] state: " + state);
                    if (state == ResourceState.Loaded){
                        // BB10 supposelly has some problems of images that are bigger than 2048x2048 px...
                        iv_image.image = imageTracker.image;
                        wallpapperFit();
                    }
                }
            }
        ]
    } // end of ImageView
    // Drag gesture
    onTouch: {
        // Determine the location inside the image that was touched,
        // relative to the container, and move it accordingly
        if (iv_image.pinchHappening) {
            // A pinch was started by touching the image with a second finger
            // so interrupt any ongoing drag gesture
            iv_image.dragHappening = false
        } else {
            if (event.isDown()) {
                // Start a dragging gesture
                iv_image.dragHappening = true
                iv_image.initialWindowX = event.windowX
                iv_image.initialWindowY = event.windowY
            } else if (iv_image.dragHappening && event.isMove()) {
                var tx = (event.windowX - iv_image.initialWindowX), ty = (event.windowY - iv_image.initialWindowY);
                //console.log("[ImageEditor.iv_image.PinchHandler.onTouch.move] tx: " + tx+", ty: "+ty);
                // Move the image and record its new position ONLY if moved more than 2xdragFactor
                if(!iv_image.canMoveX){
                    iv_image.initialWindowX = event.windowX
                    iv_image.canMoveX = mabs(tx) > iv_image.minimalMovement;
                }
                else{
                    iv_image.translationX += tx * iv_image.dragFactor
                    iv_image.initialWindowX = event.windowX
                }
                
                if(!iv_image.canMoveY){
                    iv_image.initialWindowY = event.windowY
                    iv_image.canMoveY = mabs(ty) > iv_image.minimalMovement;
                }
                else{
                    iv_image.translationY += ty * iv_image.dragFactor
                    iv_image.initialWindowY = event.windowY
                }
                
                console.log("[ImageEditor.iv_image.PinchHandler.onTouch.move] translationX: " + iv_image.translationX+", translationY: "+iv_image.translationY);
            } else {
                // Event type is Up or Cancel
                // Interrupt any ongoing drag gesture
                iv_image.dragHappening = false;
                iv_image.canMoveX = false; 
                iv_image.canMoveY = false;
                
                // use 6 digit precision
                var s = iv_image.scaleX.toFixed(6);
                
                console.log("[ImageEditor.iv_image.PinchHandler.onTouch.end] s: " + s+", wallpaperRatio: "+iv_image.wallpaperRatio);
                
                // don't let the image be out of position if not zoomed in
                
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
                //console.log("[ImageEditor.iv_image.PinchHandler.onPinchUpdated] event.rotation: " + event.rotation+", event.distance: "+event.distance);
                // Rescale and rotate as the pinch expands/contracts/rotates
                var s = iv_image.initialScale + ((event.pinchRatio - 1) * iv_image.scaleFactor);
                iv_image.scaleX = s;
                iv_image.scaleY = s;
                iv_image.rotationZ = iv_image.initialRotationZ + ((event.rotation) * iv_image.rotationFactor);
            }
            onPinchEnded: {
                // Allow a drag gesture to begin
                iv_image.pinchHappening = false;
                console.log("[ImageEditor.iv_image.PinchHandler.onPinchEnded] scaleX: " + iv_image.scaleX+", scaleY: " + iv_image.scaleY+", rotationZ: "+iv_image.rotationZ);
                
                // The user can't scale down the image
                if(iv_image.scaleX < iv_image.wallpaperRatio){
                    iv_image.scaleX = iv_image.wallpaperRatio; 
                }
                if(iv_image.scaleY < iv_image.wallpaperRatio){
                    iv_image.scaleY = iv_image.wallpaperRatio; 
                }
                
                // the image is on the minimal scale: rotate every 90o
                if(iv_image.scaleY == iv_image.wallpaperRatio && iv_image.scaleX == iv_image.wallpaperRatio){
                    var rz = iv_image.rotationZ;
                    
                    // rotating clock-wize
                    if(rz > -15.0 && rz < 15.0){
                        iv_image.rotationZ = 0.0;
                    }
                    else if(rz >= 15.0 && rz < 105.0){
                        iv_image.rotationZ = 90.0;
                    }
                    else if(rz >= 105.0 && rz < 195.0){
                        iv_image.rotationZ = 180.0;
                    }
                    else if(rz >= 195.0 && rz < 285.0){
                        iv_image.rotationZ = 270.0;                    
                    }
                    else if(rz >= 285.0 && rz < 360.0){
                        iv_image.rotationZ = 360.0;                    
                    }
                    
                    // rotating COUNTER clock-wize
                    if(rz <= -15.0 && rz > -105.0){
                        iv_image.rotationZ = -90.0;
                    }
                    else if(rz <= -105.0 && rz > -195.0){
                        iv_image.rotationZ = -180.0;
                    }
                    else if(rz <= -195.0 && rz > -285.0){
                        iv_image.rotationZ = -270.0;                    
                    }
                    else if(rz <= -285.0 && rz > -360.0){
                        iv_image.rotationZ = -360.0;                    
                    }
                }
            }
        }
    ]
} // end of Container