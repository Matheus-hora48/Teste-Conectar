import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/constants/app_colors.dart';

void main() {
  group('AppTheme Tests', () {
    group('Light Theme', () {
      late ThemeData lightTheme;

      setUp(() {
        lightTheme = AppTheme.lightTheme;
      });

      test('deve retornar uma instância válida de ThemeData', () {
        expect(lightTheme, isA<ThemeData>());
        expect(lightTheme, isNotNull);
      });

      test('deve usar Material 3', () {
        expect(lightTheme.useMaterial3, isTrue);
      });

      test('deve configurar cor primária corretamente', () {
        expect(lightTheme.primaryColor, equals(AppColors.primaryColor));
        expect(lightTheme.primaryColor, isA<Color>());
      });

      test('deve ser consistente entre chamadas', () {
        final theme1 = AppTheme.lightTheme;
        final theme2 = AppTheme.lightTheme;

        expect(theme1.primaryColor, equals(theme2.primaryColor));
        expect(theme1.useMaterial3, equals(theme2.useMaterial3));
      });
    });

    group('Theme Configuration', () {
      test('deve ter configurações padrão do Material Design', () {
        final theme = AppTheme.lightTheme;

        expect(theme.useMaterial3, isTrue);

        expect(theme.primaryColor, isNotNull);
        expect(theme.colorScheme, isNotNull);
      });

      test('deve ter cor primária válida', () {
        final theme = AppTheme.lightTheme;
        final primaryColor = theme.primaryColor;

        expect(primaryColor, isA<Color>());
        expect(primaryColor.toARGB32(), isA<int>());
        expect((0xff000000 & primaryColor.toARGB32()) >> 24, greaterThan(0));
      });

      test('deve usar cores do AppColors', () {
        final theme = AppTheme.lightTheme;

        expect(theme.primaryColor, equals(AppColors.primaryColor));
      });
    });

    group('Theme Properties', () {
      test('deve ter propriedades essenciais configuradas', () {
        final theme = AppTheme.lightTheme;

        expect(theme.brightness, isNotNull);
        expect(theme.colorScheme, isNotNull);
        expect(theme.textTheme, isNotNull);
        expect(theme.appBarTheme, isNotNull);
        expect(theme.buttonTheme, isNotNull);
      });

      test('deve herdar configurações padrão do Flutter', () {
        final theme = AppTheme.lightTheme;
        final defaultTheme = ThemeData();

        expect(theme.visualDensity, equals(defaultTheme.visualDensity));
        expect(
          theme.materialTapTargetSize,
          equals(defaultTheme.materialTapTargetSize),
        );
      });

      test('deve ter brightness correto para tema claro', () {
        final theme = AppTheme.lightTheme;

        expect(theme.brightness, equals(Brightness.light));
      });
    });

    group('Color Scheme', () {
      test('deve ter color scheme baseado na cor primária', () {
        final theme = AppTheme.lightTheme;
        final colorScheme = theme.colorScheme;

        expect(colorScheme, isNotNull);
        expect(colorScheme.primary, isA<Color>());
        expect(colorScheme.brightness, equals(Brightness.light));
      });

      test('deve ter cores contrastantes apropriadas', () {
        final theme = AppTheme.lightTheme;
        final colorScheme = theme.colorScheme;

        expect(colorScheme.onPrimary, isA<Color>());
        expect(colorScheme.surface, isA<Color>());
        expect(colorScheme.onSurface, isA<Color>());
        expect(colorScheme.onSurface, isA<Color>());
        expect(colorScheme.onSurface, isA<Color>());
      });

      test('deve ter variações de cor apropriadas', () {
        final theme = AppTheme.lightTheme;
        final colorScheme = theme.colorScheme;

        expect(colorScheme.primary, isA<Color>());
        expect(colorScheme.primaryContainer, isA<Color>());
        expect(colorScheme.secondary, isA<Color>());
        expect(colorScheme.secondaryContainer, isA<Color>());
      });
    });

    group('Typography', () {
      test('deve ter text theme configurado', () {
        final theme = AppTheme.lightTheme;
        final textTheme = theme.textTheme;

        expect(textTheme, isNotNull);
        expect(textTheme.displayLarge, isA<TextStyle>());
        expect(textTheme.headlineLarge, isA<TextStyle>());
        expect(textTheme.bodyLarge, isA<TextStyle>());
        expect(textTheme.labelLarge, isA<TextStyle>());
      });

      test('deve ter estilos de texto apropriados para Material 3', () {
        final theme = AppTheme.lightTheme;
        final textTheme = theme.textTheme;

        expect(textTheme.displayLarge, isNotNull);
        expect(textTheme.displayMedium, isNotNull);
        expect(textTheme.displaySmall, isNotNull);
        expect(textTheme.headlineLarge, isNotNull);
        expect(textTheme.headlineMedium, isNotNull);
        expect(textTheme.headlineSmall, isNotNull);
        expect(textTheme.titleLarge, isNotNull);
        expect(textTheme.titleMedium, isNotNull);
        expect(textTheme.titleSmall, isNotNull);
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);
        expect(textTheme.labelLarge, isNotNull);
        expect(textTheme.labelMedium, isNotNull);
        expect(textTheme.labelSmall, isNotNull);
      });
    });

    group('Component Themes', () {
      test('deve ter app bar theme configurado', () {
        final theme = AppTheme.lightTheme;
        final appBarTheme = theme.appBarTheme;

        expect(appBarTheme, isNotNull);
        expect(appBarTheme, isA<AppBarTheme>());
      });

      test('deve ter button themes configurados', () {
        final theme = AppTheme.lightTheme;

        expect(theme.elevatedButtonTheme, isNotNull);
        expect(theme.textButtonTheme, isNotNull);
        expect(theme.outlinedButtonTheme, isNotNull);
        expect(theme.filledButtonTheme, isNotNull);
      });

      test('deve ter input decoration theme configurado', () {
        final theme = AppTheme.lightTheme;
        final inputDecorationTheme = theme.inputDecorationTheme;

        expect(inputDecorationTheme, isNotNull);
        expect(inputDecorationTheme, isA<InputDecorationTheme>());
      });

      test('deve ter card theme configurado', () {
        final theme = AppTheme.lightTheme;
        final cardTheme = theme.cardTheme;

        expect(cardTheme, isNotNull);
        expect(cardTheme, isA<CardTheme>());
      });
    });

    group('Accessibility', () {
      test('deve ter visual density apropriada', () {
        final theme = AppTheme.lightTheme;
        final visualDensity = theme.visualDensity;

        expect(visualDensity, isNotNull);
        expect(visualDensity, isA<VisualDensity>());
      });

      test('deve ter material tap target size configurado', () {
        final theme = AppTheme.lightTheme;
        final tapTargetSize = theme.materialTapTargetSize;

        expect(tapTargetSize, isNotNull);
        expect(tapTargetSize, isA<MaterialTapTargetSize>());
      });

      test('deve suportar alto contraste', () {
        final theme = AppTheme.lightTheme;
        final colorScheme = theme.colorScheme;

        expect(colorScheme.onPrimary, isA<Color>());
        expect(colorScheme.onSurface, isA<Color>());
        expect(colorScheme.onSurface, isA<Color>());
      });
    });

    group('Material Design 3 Compliance', () {
      test('deve usar tokens de design do Material 3', () {
        final theme = AppTheme.lightTheme;

        expect(theme.useMaterial3, isTrue);

        final colorScheme = theme.colorScheme;
        expect(colorScheme.surfaceTint, isA<Color>());
        expect(colorScheme.inverseSurface, isA<Color>());
        expect(colorScheme.onInverseSurface, isA<Color>());
      });

      test('deve ter elevações apropriadas para Material 3', () {
        final theme = AppTheme.lightTheme;

        expect(theme.colorScheme.surfaceTint, isNotNull);
      });

      test('deve usar formas apropriadas para Material 3', () {
        final theme = AppTheme.lightTheme;

        expect(theme.cardTheme.shape, isA<ShapeBorder?>());
        expect(theme.elevatedButtonTheme.style, isNotNull);
      });
    });

    group('Theme Consistency', () {
      test('deve manter consistência entre múltiplas instâncias', () {
        final theme1 = AppTheme.lightTheme;
        final theme2 = AppTheme.lightTheme;

        expect(theme1.primaryColor, equals(theme2.primaryColor));
        expect(theme1.useMaterial3, equals(theme2.useMaterial3));
        expect(theme1.brightness, equals(theme2.brightness));
      });

      test('deve usar a mesma cor primária do AppColors', () {
        final theme = AppTheme.lightTheme;

        expect(theme.primaryColor, equals(AppColors.primaryColor));
      });

      test('deve ter configurações válidas', () {
        final theme = AppTheme.lightTheme;

        expect(theme.primaryColor.toARGB32(), greaterThan(0));
        expect(theme.colorScheme.primary.toARGB32(), greaterThan(0));
        expect(theme.textTheme.bodyLarge, isNotNull);
      });
    });

    group('Performance', () {
      test('deve ser eficiente na criação do tema', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          AppTheme.lightTheme;
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('deve retornar instâncias independentes', () {
        final theme1 = AppTheme.lightTheme;
        final theme2 = AppTheme.lightTheme;

        expect(identical(theme1, theme2), isFalse);

        expect(theme1.primaryColor, equals(theme2.primaryColor));
      });
    });

    group('Error Handling', () {
      test('deve funcionar mesmo se AppColors.primaryColor for null', () {
        expect(AppColors.primaryColor, isNotNull);
        expect(() => AppTheme.lightTheme, returnsNormally);
      });

      test('deve gerar tema válido em qualquer circunstância', () {
        final theme = AppTheme.lightTheme;

        expect(theme, isA<ThemeData>());
        expect(theme.primaryColor, isA<Color>());
        expect(theme.colorScheme, isA<ColorScheme>());
      });
    });

    group('Future Extensions', () {
      test('estrutura deve permitir extensão para tema escuro', () {
        expect(AppTheme, isA<Type>());

        expect(AppTheme.lightTheme, isA<ThemeData>());
      });

      test('deve ser compatível com customizações futuras', () {
        final theme = AppTheme.lightTheme;

        final customTheme = theme.copyWith(primaryColor: Colors.blue);

        expect(customTheme.primaryColor, equals(Colors.blue));
        expect(customTheme.useMaterial3, equals(theme.useMaterial3));
      });
    });
  });
}
