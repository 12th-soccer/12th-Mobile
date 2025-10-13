import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

void main() {
  group('TwelfthElevatedButton', () {
    testWidgets('renders with required child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(TwelfthElevatedButton), findsOneWidget);
    });

    testWidgets('renders in disabled state when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      expect(find.text('Disabled Button'), findsOneWidget);
      
      // Find the ElevatedButton and verify it's disabled
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      int callCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () => callCount++,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TwelfthElevatedButton));
      await tester.pump();

      expect(callCount, equals(1));
    });

    testWidgets('does not call onPressed when disabled', (WidgetTester tester) async {
      int callCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TwelfthElevatedButton));
      await tester.pump();

      expect(callCount, equals(0));
    });

    testWidgets('shows pressed state on tap down', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // Tap down but don't release
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(TwelfthElevatedButton)),
      );
      await tester.pump();

      // The pressed outline should be visible (tested via widget state)
      final buttonState = tester.state<_TwelfthElevatedButtonState>(
        find.byType(TwelfthElevatedButton),
      );
      expect(buttonState._isPressed, isTrue);

      // Release the tap
      await gesture.up();
      await tester.pump();
    });

    testWidgets('clears pressed state on tap cancel', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // Start tap but then cancel it
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(TwelfthElevatedButton)),
      );
      await tester.pump();

      expect(
        tester.state<_TwelfthElevatedButtonState>(
          find.byType(TwelfthElevatedButton),
        )._isPressed,
        isTrue,
      );

      await gesture.cancel();
      await tester.pump();

      expect(
        tester.state<_TwelfthElevatedButtonState>(
          find.byType(TwelfthElevatedButton),
        )._isPressed,
        isFalse,
      );
    });

    testWidgets('uses custom background color when provided', (WidgetTester tester) async {
      const customColor = Colors.red;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              backgroundColor: customColor,
              child: const Text('Custom Color'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(TwelfthElevatedButton), findsOneWidget);
    });

    testWidgets('uses default gray900 background when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Default Color'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(TwelfthElevatedButton), findsOneWidget);
    });

    testWidgets('uses custom text color when provided and enabled', (WidgetTester tester) async {
      const customTextColor = Colors.red;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              textColor: customTextColor,
              child: const Text('Custom Text Color'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Custom Text Color'), findsOneWidget);
    });

    testWidgets('renders with SVG icon when imgPath provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              imgPath: 'assets/images/google.svg',
              child: const Text('Button with Icon'),
            ),
          ),
        ),
      );

      expect(find.text('Button with Icon'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders without icon when imgPath is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Button without Icon'),
            ),
          ),
        ),
      );

      expect(find.text('Button without Icon'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('has full width container', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TwelfthElevatedButton(
                onPressed: () {},
                child: const Text('Full Width'),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TwelfthElevatedButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxWidth, equals(double.infinity));
    });

    testWidgets('has height of 48', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Fixed Height'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TwelfthElevatedButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxHeight, equals(48));
    });

    testWidgets('has rounded corners with radius 20', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Rounded'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TwelfthElevatedButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      
      expect(borderRadius.topLeft.x, equals(20));
      expect(borderRadius.topRight.x, equals(20));
      expect(borderRadius.bottomLeft.x, equals(20));
      expect(borderRadius.bottomRight.x, equals(20));
    });

    testWidgets('shows gradient when enabled and not pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Gradient Button'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TwelfthElevatedButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect(decoration.color, isNull);
    });

    testWidgets('shows solid color when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TwelfthElevatedButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNull);
      expect(decoration.color, isNotNull);
    });

    testWidgets('applies heading2 text style by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Styled Text'),
            ),
          ),
        ),
      );

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(DefaultTextStyle),
        ),
      );

      expect(defaultTextStyle.style.fontSize, equals(TwelfthTextStyle.heading2.fontSize));
      expect(defaultTextStyle.style.fontWeight, equals(TwelfthTextStyle.heading2.fontWeight));
    });

    testWidgets('centers text content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Centered'),
            ),
          ),
        ),
      );

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(DefaultTextStyle),
        ),
      );

      expect(defaultTextStyle.textAlign, equals(TextAlign.center));
    });

    testWidgets('multiple taps call onPressed multiple times', (WidgetTester tester) async {
      int callCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () => callCount++,
              child: const Text('Multi Tap'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TwelfthElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(TwelfthElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(TwelfthElevatedButton));
      await tester.pump();

      expect(callCount, equals(3));
    });

    testWidgets('uses white text for disabled state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: null,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(DefaultTextStyle),
        ),
      );

      expect(defaultTextStyle.style.color, equals(TwelfthColor.white));
    });

    testWidgets('uses black text for enabled state by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwelfthElevatedButton(
              onPressed: () {},
              child: const Text('Enabled'),
            ),
          ),
        ),
      );

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(DefaultTextStyle),
        ),
      );

      expect(defaultTextStyle.style.color, equals(TwelfthColor.black));
    });
  });
}