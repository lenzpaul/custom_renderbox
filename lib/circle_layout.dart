import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class RenderCircleLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CircleLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CircleLayoutParentData> {
  double radius;

  RenderCircleLayout({required this.radius});
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CircleLayoutParentData) {
      child.parentData = CircleLayoutParentData();
    }
  }

  @override
  void performLayout() {
    // The angle for each child. It starts at 0 and increases by the step for
    // each child.
    double angle = 0;

    // The angle step for each child. It is calculated so that all children are
    // evenly spaced around the circle.
    final double step = 2 * math.pi / childCount;

    // The constraints for the children.
    //
    // Allow for each child to be able to size itself based on its content,
    // within the maximum allowable space.
    final constraints = this.constraints.loosen();

    // If you want to force the children to have a specific size, you can use
    // the following line instead of the one above. It will force the children
    // to take the available space, but it will not allow them to be bigger than
    // that.
    //
    // Sets maxWidth and maxHeight to the minimum of the available space.
    // final constraints = this.constraints.tighten();

    RenderBox? child = firstChild;

    // Iterate over all the children and layout them in a circle
    while (child != null) {
      // Compute the size and position of the child
      child.layout(
        constraints,
        parentUsesSize: true,
      );

      // The parentData is used to store the position of the child in the circle
      final CircleLayoutParentData childParentData =
          child.parentData! as CircleLayoutParentData;

      childParentData.offset = _calculateChildOffset(angle, child, radius);

      angle += step;
      child = childParentData.nextSibling;
    }

    // Set the size of the container to the diameter of the circle
    size = Size(2 * radius, 2 * radius);
  }

  /// Paints the children. The [offset] parameter represents the offset at which
  /// the children will be painted.
  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;

    while (child != null) {
      final CircleLayoutParentData childParentData =
          child.parentData! as CircleLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);

      child = childParentData.nextSibling;
    }
  }
}

/// Parent data for a child in a [CircleLayout].
///
/// This class extends [ContainerBoxParentData] and is used to store layout
/// information for [RenderBox] children of [CircleLayout].
class CircleLayoutParentData extends ContainerBoxParentData<RenderBox> {}

/// {@template circle_layout}
/// A layout widget that positions its children in a circle.
///
/// This is the actual widget that we will use in our application. It uses the
/// [RenderCircleLayout] render object to layout its children in a circle.
/// {@endtemplate}
class CircleLayout extends MultiChildRenderObjectWidget {
  final double radius;

  /// {@macro circle_layout}
  const CircleLayout({
    super.key,
    required this.radius,
    required super.children,
  });

  /// Creates the render object for this widget. Called by the framework when
  /// this widget is added to the tree.
  @override
  RenderCircleLayout createRenderObject(BuildContext context) {
    return RenderCircleLayout(radius: radius);
  }

  /// Updates the render object for this widget. Called by the framework when
  /// the widget is updated.
  ///
  /// Note that we are updating the radius of the render object here. This is
  /// because the widget is immutable, and not the render object. This means that
  /// the render object instance will be the same across multiple builds of the
  /// widget, and we need to update its properties to reflect the new widget
  /// properties.
  @override
  void updateRenderObject(
      BuildContext context, RenderCircleLayout renderObject) {
    renderObject.radius = radius;
  }
}

/// Calculates the offset of a child widget around the circle.
Offset _calculateChildOffset(double angle, RenderBox child, double radius) {
  double xCoordinate = radius * math.cos(angle);
  double xCenterOffset = radius - child.size.width / 2;
  double yCoordinate = radius * math.sin(angle);
  double yCenterOffset = radius - child.size.height / 2;

  return Offset(xCoordinate + xCenterOffset, yCoordinate + yCenterOffset);
}
