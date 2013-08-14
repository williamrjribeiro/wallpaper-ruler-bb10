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
        step = 0;
        // Must reset the ImageView and the ImageTracker or else if the user selecs the same file
        // it won't be loaded
        iv_image.resetImage();
        imageTracker.imageSource = "";
    
    }
    // Optimized mathematical functions.JSPerf shows that native implementation is faster (Math.abs)
    // http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
    // http://jsperf.com/math-abs-vs-bitwise/8
    // http://jsperf.com/bitwise-math-abs
    /*function mabs(val){
        return (val ^ (val >> 31)) - (val >> 31);
    }*/
    function wallpapperFit(){
        var ratio = 1.0;
        
        // Calculate the correct scale based on the loaded image!
        if(imageTracker.width > imageTracker.height)
            ratio = imageTracker.width / imageTracker.height;
        
        iv_image.scaleX = ratio;
        iv_image.scaleY = ratio;
        iv_image.initialScale = ratio;
        
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
        property double initialWindowX
        property double initialWindowY
        
        // How fast the image moves in response to the drag gesture
        property double dragFactor: 1.25
        
        // the minimal touch movement needed in order to make changes 
        property double minimalMovement: 1.0
        
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
    property int step: 1
    gestureHandlers: [
        TapHandler {
            onTapped: {
                /*if(step == 0){
                    iv_image.scaleX = 0.5;
                    iv_image.scaleY = 0.5;
                }
                else if(step == 1){
                    iv_image.rotationZ = 45;
                }
                else if(step == 2){
                    iv_image.translationX = - (imageTracker.width * 0.5) / 2;
                    iv_image.translationY = - (imageTracker.height * 0.5) / 2;
                }*/
                iv_image.rotationZ = 45;
                step++;
            }
        },
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
                iv_image.rotationZ = iv_image.initialRotationZ + ((event.rotation) * iv_image.rotationFactor);
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