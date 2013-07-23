import bb.cascades 1.0

Container {
    // The top-level container uses a dock layout so that the image can
    // always remain centered on the screen as it changes size
    layout: DockLayout {
    }
    property alias image: imageTracker
    property alias myImageElement: iv_image
    background: Color.Black
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    implicitLayoutAnimationsEnabled: false
    function resetEdits(){
        console.log("[ImageEditor.resetEdits]");
        iv_image.scaleX = 0.0;
        iv_image.scaleY = 0.0;
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
        
        var ratio = 0.0;
        
        if(imageTracker.width > imageTracker.height)
        	ratio += imageTracker.width / imageTracker.height;
        else if(imageTracker.width < imageTracker.height)
            ratio += imageTracker.height / imageTracker.width;
        
        ratio = _screenSize.width / _screenSize.height;
        
        console.log("[ImageEditor.wallpapperFit] imageTracker.width: " + imageTracker.width
        			+", imageTracker.height: " + imageTracker.height
        			+ ", ratio: " + ratio);
        
        iv_image.scaleX = ratio;
        iv_image.scaleY = ratio;
        
        console.log("[ImageEditor.wallpapperFit] iv_image.scaleX: " + iv_image.scaleX+", iv_image.scaleY: " + iv_image.scaleY);
    }
    ImageView {
        id: iv_image
        
        // Flag to prevent a drag gesture from starting during pinch
        property bool pinchHappening: false
        
        // The scale of the image when a pinch gesture begins
        property double initialScale: 1.0
        
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
        
        // The image is initially centered on the container
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
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
        
        // Drag gesture
        onTouch: {
            // Determine the location inside the image that was touched,
            // relative to the container, and move it accordingly
            if (pinchHappening) {
                // A pinch was started by touching the image with a second finger
                // so interrupt any ongoing drag gesture
                dragHappening = false
            } else {
                if (event.isDown()) {
                    // Start a dragging gesture
                    dragHappening = true
                    initialWindowX = event.windowX
                    initialWindowY = event.windowY
                } else if (dragHappening && event.isMove()) {
                    var tx = (event.windowX - initialWindowX), ty = (event.windowY - initialWindowY);
                    //console.log("[ImageEditor.iv_image.PinchHandler.onTouch] tx: " + tx+", ty: "+ty);
                    // Move the image and record its new position ONLY if moved more than 2xdragFactor
                    if(!canMoveX){
                        initialWindowX = event.windowX
                    	canMoveX = mabs(tx) > minimalMovement;
                    }
                    else{
                        translationX += tx * dragFactor
                        initialWindowX = event.windowX
                    }
                    
                    if(!canMoveY){
                    	initialWindowY = event.windowY
                    	canMoveY = mabs(ty) > minimalMovement;
                    }
                    else{
                    	translationY += ty * dragFactor
                    	initialWindowY = event.windowY
                    }
                } else {
                    // Event type is Up or Cancel
                    // Interrupt any ongoing drag gesture
                    dragHappening = false
                    canMoveX = false 
                    canMoveY = false
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
                    iv_image.pinchHappening = false
                    console.log("[ImageEditor.iv_image.PinchHandler.onPinchEnded] iv_image.scaleX: " + iv_image.scaleX+", iv_image.scaleY: " + iv_image.scaleY);
                }
            }
        ]
        scalingMethod: ScalingMethod.AspectFit
        loadEffect: ImageViewLoadEffect.None
    } // end of ImageView
} // end of Container