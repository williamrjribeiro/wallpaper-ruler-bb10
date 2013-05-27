import bb.cascades 1.0

Container {
    // The top-level container uses a dock layout so that the image can
    // always remain centered on the screen as it changes size
    layout: DockLayout {
    }
    property alias image: myImage 
    background: Color.Black
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
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
        property double rotationFactor: 1.5
        
        // Flag to prevent dragging when a pinch ends but the two fingers are
        // not taken off the screen simultaneously
        property bool dragHappening: false
        
        // The position of the image when a drag gesture begins
        property double initialWindowX
        property double initialWindowY
        
        // How fast the image moves in response to the drag gesture
        property double dragFactor: 1.25
        
        // The image is initially centered on the container
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
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
                    // Move the image and record its new position
                    translationX += (event.windowX - initialWindowX) * dragFactor
                    translationY += (event.windowY - initialWindowY) * dragFactor
                    initialWindowX = event.windowX
                    initialWindowY = event.windowY
                } else {
                    // Event type is Up or Cancel
                    // Interrupt any ongoing drag gesture
                    dragHappening = false
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
                    // Rescale and rotate as the pinch expands/contracts/rotates
                    var s = myImage.initialScale + ((event.pinchRatio - 1) * myImage.scaleFactor);
                    myImage.scaleX = s;
                    myImage.scaleY = s;
                    myImage.rotationZ = myImage.initialRotationZ + ((event.rotation) * myImage.rotationFactor);
                }
                onPinchEnded: {
                    // Allow a drag gesture to begin
                    myImage.pinchHappening = false
                }
            }
        ]
        scalingMethod: ScalingMethod.AspectFit
    } // end of ImageView
} // end of Container