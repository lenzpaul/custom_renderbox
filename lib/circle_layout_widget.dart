import 'package:custom_renderbox_mbo/render_circle_layout.dart';
import 'package:flutter/material.dart';

/// {@template circle_layout}
/// A layout widget that positions its children in a circle.
///
/// This is the actual widget that we will use in our application. It uses the
/// [RenderCircleLayout] render object to layout its children in a circle.
/// {@endtemplate}
class CircleLayout extends MultiChildRenderObjectWidget {
  /// {@macro radius}
  final double radius;

  /// {@macro childrenSize}
  final Size? childrenSize;

  final bool showCircle;

  /// {@macro circle_layout}
  const CircleLayout({
    super.key,
    required this.radius,
    this.showCircle = false,
    required super.children,
    this.childrenSize,
  });

  /// Creates the render object for this widget. Called by the framework when
  /// this widget is added to the tree.
  @override
  RenderCircleLayout createRenderObject(BuildContext context) {
    return RenderCircleLayout(
      radius: radius,
      childrenSize: childrenSize,
      showCircle: showCircle,
    );
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
    renderObject.childrenSize = childrenSize;
    renderObject.showCircle = showCircle;
  }
}
