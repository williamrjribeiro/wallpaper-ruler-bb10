import bb.cascades 1.0

Container {
    // The top-level container uses a dock layout so that the image can
    // always remain centered on the screen as it changes size
    layout: DockLayout {
    }
    property alias image: tracker 
    background: Color.Black
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    //minHeight: 1280
    implicitLayoutAnimationsEnabled: false
    function resetEdits(){
        myImage.scaleX = 0.0;
        myImage.scaleY = 0.0;
        myImage.translationX = 0.0;
        myImage.translationY = 0.0;
        myImage.rotationZ = 0.0;
    }
    function mabs(val){
    	return (val ^ (val >> 31)) - (val >> 31);
    }
    function wallpapperFit(){
        console.log("[ImageEditor.wallpapperFit] tracker.width: " + tracker.width+", tracker.height: " + tracker.height);
        var ratio = 1.0;
        
        if(tracker.width > tracker.height)
        	ratio = tracker.width / tracker.height;
        else if(tracker.width < tracker.height)
            ratio = tracker.height / tracker.width;
        
        myImage.scaleX = ratio;
        myImage.scaleY = ratio;
        
        console.log("[ImageEditor.wallpapperFit] myImage.scaleX: " + myImage.scaleX+", myImage.scaleY: " + myImage.scaleY);
    }
    ImageView {
        id: myImage
        
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
                id: tracker
                onStateChanged: { 
                    if (state == ResourceState.Loaded){
                        // BB10 is limited to images that are smaller than 2048x2048 px.
                        if(tracker.height * tracker.width <= 4194304){
                            myImage.image = tracker.image;
                            wallpapperFit();
                        }
                        else {
                            console.error("[ImageEditor.myImage.tracker.onStateChanged] IMAGE IS TOO BIG FOR DEVICE!");
                        }
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
                    console.log("[ImageEditor.myImage.PinchHandler.onTouch] tx: " + tx+", ty: "+ty);
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
                    myImage.initialScale = myImage.scaleX
                    myImage.initialRotationZ = myImage.rotationZ
                    // Prevent a drag gesture from starting during pinch
                    myImage.pinchHappening = true
                }
                onPinchUpdated: {
                    console.log("[ImageEditor.myImage.PinchHandler.onPinchEnded] event.rotation: " + event.rotation+", event.distance: "+event.distance);
                    // Rescale and rotate as the pinch expands/contracts/rotates
                    var s = myImage.initialScale + ((event.pinchRatio - 1) * myImage.scaleFactor);
                    myImage.scaleX = s;
                    myImage.scaleY = s;
                    myImage.rotationZ = myImage.initialRotationZ + ((event.rotation) * myImage.rotationFactor);
                }
                onPinchEnded: {
                    // Allow a drag gesture to begin
                    myImage.pinchHappening = false
                    console.log("[ImageEditor.myImage.PinchHandler.onPinchEnded] myImage.scaleX: " + myImage.scaleX+", myImage.scaleY: " + myImage.scaleY);
                }
            }
        ]
        scalingMethod: ScalingMethod.AspectFit
        loadEffect: ImageViewLoadEffect.None
    } // end of ImageView
} // end of Container