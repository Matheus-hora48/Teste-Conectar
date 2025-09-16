import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    group('Primary Color', () {
      test('deve ter cor primária definida', () {
        expect(AppColors.primaryColor, isA<Color>());
        expect(AppColors.primaryColor, isNotNull);
      });

      test('deve ter valor correto da cor primária', () {
        expect(AppColors.primaryColor.toARGB32(), equals(0xFF1bb17a));
      });

      test('deve ter componentes RGB corretos', () {
        final color = AppColors.primaryColor;

        expect((color.r * 255.0).round() & 0xff, equals(27));
        expect((color.g * 255.0).round() & 0xff, equals(177));
        expect((color.b * 255.0).round() & 0xff, equals(122));
        expect((color.a * 255.0).round() & 0xff, equals(255));
      });

      test('deve ter opacidade total por padrão', () {
        expect(AppColors.primaryColor.a, equals(1.0));
      });

      test('deve ser uma cor válida', () {
        expect(AppColors.primaryColor.toARGB32(), greaterThan(0));
        expect(
          AppColors.primaryColor.toARGB32(),
          lessThanOrEqualTo(0xFFFFFFFF),
        );
      });

      test('deve manter consistência entre acessos', () {
        final color1 = AppColors.primaryColor;
        final color2 = AppColors.primaryColor;

        expect(color1, equals(color2));
        expect(color1.toARGB32(), equals(color2.toARGB32()));
      });

      test('deve ter representação hexadecimal correta', () {
        final hexValue = AppColors.primaryColor
            .toARGB32()
            .toRadixString(16)
            .toUpperCase();

        expect(hexValue, equals('FF1BB17A'));
      });

      test(
        'deve ser uma cor visualmente agradável (não muito clara ou escura)',
        () {
          final color = AppColors.primaryColor;
          final brightness =
              ((color.r * 255.0).round() * 0.299 +
              (color.g * 255.0).round() * 0.587 +
              (color.b * 255.0).round() * 0.114);

          expect(brightness, greaterThan(50));
          expect(brightness, lessThan(200));
        },
      );

      test('deve ser uma cor no espectro verde', () {
        final color = AppColors.primaryColor;

        expect(
          (color.g * 255.0).round() & 0xff,
          greaterThan((color.r * 255.0).round() & 0xff),
        );
        expect(
          (color.g * 255.0).round() & 0xff,
          greaterThan((color.b * 255.0).round() & 0xff),
        );
      });

      test('deve permitir criação de variações da cor', () {
        final lighterColor = AppColors.primaryColor.withValues(alpha: 0.5);
        final darkerColor = Color.lerp(
          AppColors.primaryColor,
          Colors.black,
          0.2,
        );

        expect(lighterColor.a, closeTo(0.5, 0.01));
        expect(darkerColor, isNotNull);
        expect(
          (darkerColor!.r * 255.0).round() & 0xff,
          lessThan((AppColors.primaryColor.r * 255.0).round() & 0xff),
        );
      });
    });

    group('Color Consistency', () {
      test('deve manter valores constantes', () {
        const expectedValue = 0xFF1bb17a;

        expect(AppColors.primaryColor.toARGB32(), equals(expectedValue));

        for (int i = 0; i < 5; i++) {
          expect(AppColors.primaryColor.toARGB32(), equals(expectedValue));
        }
      });

      test('deve ser imutável', () {
        final originalColor = AppColors.primaryColor;
        final sameColor = AppColors.primaryColor;

        expect(identical(originalColor, sameColor), isTrue);
      });
    });

    group('Material Design Compatibility', () {
      test('deve ser compatível com Material Theme', () {
        final theme = ThemeData(primarySwatch: Colors.green);
        final colorScheme = ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        );

        expect(colorScheme.primary, isA<Color>());
        expect(theme.primaryColor, isA<Color>());
      });

      test('deve funcionar com diferentes opacidades', () {
        final opacities = [0.1, 0.3, 0.5, 0.7, 0.9];

        for (final opacity in opacities) {
          final colorWithOpacity = AppColors.primaryColor.withValues(
            alpha: opacity,
          );

          expect(colorWithOpacity.a, closeTo(opacity, 0.01));
          expect(
            (colorWithOpacity.r * 255.0).round() & 0xff,
            equals((AppColors.primaryColor.r * 255.0).round() & 0xff),
          );
          expect(
            (colorWithOpacity.g * 255.0).round() & 0xff,
            equals((AppColors.primaryColor.g * 255.0).round() & 0xff),
          );
          expect(
            (colorWithOpacity.b * 255.0).round() & 0xff,
            equals((AppColors.primaryColor.b * 255.0).round() & 0xff),
          );
        }
      });

      test('deve permitir interpolação de cores', () {
        final interpolatedToWhite = Color.lerp(
          AppColors.primaryColor,
          Colors.white,
          0.5,
        );
        final interpolatedToBlack = Color.lerp(
          AppColors.primaryColor,
          Colors.black,
          0.5,
        );

        expect(interpolatedToWhite, isNotNull);
        expect(interpolatedToBlack, isNotNull);
        expect(
          (interpolatedToWhite!.r * 255.0).round() & 0xff,
          greaterThan((AppColors.primaryColor.r * 255.0).round() & 0xff),
        );
        expect(
          (interpolatedToBlack!.r * 255.0).round() & 0xff,
          lessThan((AppColors.primaryColor.r * 255.0).round() & 0xff),
        );
      });
    });

    group('Accessibility', () {
      test('deve ter contraste adequado com branco', () {
        final luminance = AppColors.primaryColor.computeLuminance();
        final whiteLuminance = Colors.white.computeLuminance();
        final contrastRatio = (whiteLuminance + 0.05) / (luminance + 0.05);

        expect(contrastRatio, greaterThan(2.5));
      });

      test('deve ter contraste adequado com preto', () {
        final luminance = AppColors.primaryColor.computeLuminance();
        final blackLuminance = Colors.black.computeLuminance();
        final contrastRatio = (luminance + 0.05) / (blackLuminance + 0.05);

        expect(contrastRatio, greaterThan(3.0));
      });

      test('deve ter luminância calculável', () {
        final luminance = AppColors.primaryColor.computeLuminance();

        expect(luminance, isA<double>());
        expect(luminance, greaterThanOrEqualTo(0.0));
        expect(luminance, lessThanOrEqualTo(1.0));
      });
    });

    group('Color Theory', () {
      test('deve estar no espectro correto de verde', () {
        final hsl = HSLColor.fromColor(AppColors.primaryColor);

        expect(hsl.hue, greaterThan(90));
        expect(hsl.hue, lessThan(180));
      });

      test('deve ter saturação e luminosidade adequadas', () {
        final hsl = HSLColor.fromColor(AppColors.primaryColor);

        expect(hsl.saturation, greaterThan(0.3));
        expect(hsl.saturation, lessThan(1.0));
        expect(hsl.lightness, greaterThan(0.2));
        expect(hsl.lightness, lessThan(0.8));
      });

      test('deve converter corretamente para HSV', () {
        final hsv = HSVColor.fromColor(AppColors.primaryColor);

        expect(hsv.hue, isA<double>());
        expect(hsv.saturation, isA<double>());
        expect(hsv.value, isA<double>());
        expect(hsv.alpha, equals(1.0));
      });
    });
  });
}
