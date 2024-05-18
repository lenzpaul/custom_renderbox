# Custom Render Object 

Flutter single-pass layout algorithm. This means that no back and forth is allowed during the layout phase. 
This can be a challenge for creating columns for example. When we use mainAxisAlignment, how can we know the height of the column before we layout the children?


## Why use a Custom RenderObject?
The Flutter layout system is very powerful and flexible. It allows you to create complex layouts with ease. However, there are times when you need more control over the layout process. This is where custom render objects come in. A custom render object allows you to create your own layout algorithm and paint method. This can be useful when you need to create a layout that is not possible with the built-in widgets or when you need to optimize the layout for performance. We will explore how to create a custom render object in Flutter.

## What is a RenderObject?
Important methods in the RenderObject class:
- performLayout: figure out how size and position for itself and children if any
- paint: draw itself and children if any

Other notable methods in the RenderObject class:
- hitTest: determine if a point is inside the render object
- handleEvent: handle events like mouse clicks or keyboard input. This is where the render object can decide to do something when it receives an event.


Order of operations:
- We create the render objects, lay them out and paint them
- Eventually, when a widget's properties change, we need to update the render objects to reflect the new state. This is where the updateRenderObject method comes in. This method is called when the widget is updated and is responsible for updating the render object to reflect the new state of the widget. It will trigger a relayout and repaint if necessary. Flutter tries to minzimize the number of relayouts and repaints by only updating the render objects that have changed. Individual render objects are responsible for determining if they need to be updated or not. This can be done by calling markNeedsLayout or markNeedsPaint on the render object. This will tell the framework that the render object needs to be updated and will trigger a relayout or repaint if necessary.




