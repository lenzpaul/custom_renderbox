import 'dart:math' as math;

import 'package:custom_renderbox_mbo/circle_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// {@template render_circle_layout}
/// A render object that positions its children in a circle.
/// {@endtemplate}
class RenderCircleLayout extends RenderBox
    // These mixins provide helpful methods for managing children
    with
        ContainerRenderObjectMixin<RenderBox, CircleLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CircleLayoutParentData> {
  /// {@template radius}
  /// The radius of the circle layout around which the children will be placed.
  /// {@endtemplate}
  double radius;

  /// {@macro childrenSize}
  Size? _childrenSize;

  /// {@template childrenSize}
  /// The size of the children.
  ///
  /// If this is not provided, the children will be allowed to size themselves
  /// based on their content.
  /// {@endtemplate}
  Size? get childrenSize => _childrenSize;

  /// {@macro childrenSize}
  set childrenSize(Size? value) {
    _childrenSize = value;
    // Mark dirty to trigger a layout/paint update
    markNeedsLayout();
  }

  /// {@macro render_circle_layout}
  RenderCircleLayout({
    required this.radius,
    Size? childrenSize,
  }) : _childrenSize = childrenSize;
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CircleLayoutParentData) {
      child.parentData = CircleLayoutParentData();
    }
  }

  @override
  void performLayout() {
    // Set the size of the container that this render object represents to be
    // the diameter of the circle
    size = Size(2 * radius, 2 * radius);

    // The angle for each child. It starts at 0 and increases by the step for
    // each child.
    double angle = 0;

    // The angle step for each child. It is calculated so that all children are
    // evenly spaced around the circle.
    final double step = 2 * math.pi / childCount;

    // The constraints for the children.
    final BoxConstraints childrenConstraints = BoxConstraints(
      minWidth: childrenSize?.width ?? 0.0,
      minHeight: childrenSize?.height ?? 0.0,
      maxWidth: childrenSize?.width ?? double.infinity,
      maxHeight: childrenSize?.height ?? double.infinity,
    );

    // The first child in the list of children. This is provided by the
    // ContainerRenderObjectMixin.
    RenderBox? child = firstChild;

    // Iterate over all the children and layout them in a circle
    while (child != null) {
      // Compute the size of the child
      child.layout(
        childrenConstraints,
        parentUsesSize: true,
      );

      // The parentData is used to store the position of the child in the circle
      final CircleLayoutParentData childParentData =
          child.parentData! as CircleLayoutParentData;

      // Compute the position of the child.
      //
      // Determine where the child should be positioned relative to the top-left
      // corner of the [RenderCircleLayout]'s bounding box.
      childParentData.offset = _calculateChildOffset(angle, child, radius);

      angle += step;
      child = childParentData.nextSibling;
    }
  }

  /// Paints the children. The [offset] parameter represents the offset at which
  /// the children will be painted.
  @override
  void paint(PaintingContext context, Offset offset) {
    final Set<RenderBox> paintedChildren = {};

    // Paint the circle
    context.canvas.drawCircle(
      offset + Offset(radius, radius),
      radius,
      Paint()
        ..color = Colors.blue.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Paint the children on top of the circle and paint the overlap between the
    // children.
    RenderBox? child = firstChild;
    while (child != null) {
      final CircleLayoutParentData childParentData =
          child.parentData! as CircleLayoutParentData;

      context.paintChild(child, childParentData.offset + offset);

      paintedChildren.add(child);
      _paintOverlap(context, offset, child, paintedChildren);

      child = childParentData.nextSibling;
    }
  }
}

/// Paints the overlap between the given child and other painted children.
///
/// The [context] is the painting context used to paint the overlap.
/// The [offset] is the offset of the parent render box.
/// The [child] is the render box for which the overlap is being painted.
/// The [paintedChildren] is the set of other painted children to check for overlap.
void _paintOverlap(
  PaintingContext context,
  Offset offset,
  RenderBox child,
  Set<RenderBox> paintedChildren,
) {
  final CircleLayoutParentData childParentData =
      child.parentData! as CircleLayoutParentData;

  for (var otherChild in paintedChildren) {
    if (otherChild == child) continue;

    final CircleLayoutParentData otherChildParentData =
        otherChild.parentData! as CircleLayoutParentData;

    final Rect childRect = (childParentData.offset + offset) & child.size;
    final Rect otherChildRect =
        (otherChildParentData.offset + offset) & otherChild.size;

    if (childRect.overlaps(otherChildRect)) {
      final Rect overlapRect = childRect.intersect(otherChildRect);
      context.canvas.drawRect(
          overlapRect,
          Paint()
            ..color = Colors.red.withOpacity(0.75)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4);
    }
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

/// Parent data for a child in a [CircleLayout].
///
/// This class extends [ContainerBoxParentData] and is used to store layout
/// information for [RenderBox] children of [CircleLayout].
class CircleLayoutParentData extends ContainerBoxParentData<RenderBox> {}
