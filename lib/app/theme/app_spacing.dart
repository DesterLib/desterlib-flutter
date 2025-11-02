import 'package:flutter/material.dart';

class AppSpacing {
  static const double baseUnit = 4.0;

  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(
    horizontal: xxl,
  );

  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(
    vertical: xxl,
  );

  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXXL = SizedBox(width: xxl, height: xxl);

  static const SizedBox gapHorizontalXS = SizedBox(width: xs);
  static const SizedBox gapHorizontalSM = SizedBox(width: sm);
  static const SizedBox gapHorizontalMD = SizedBox(width: md);
  static const SizedBox gapHorizontalLG = SizedBox(width: lg);
  static const SizedBox gapHorizontalXL = SizedBox(width: xl);

  static const SizedBox gapVerticalXS = SizedBox(height: xs);
  static const SizedBox gapVerticalSM = SizedBox(height: sm);
  static const SizedBox gapVerticalMD = SizedBox(height: md);
  static const SizedBox gapVerticalLG = SizedBox(height: lg);
  static const SizedBox gapVerticalXL = SizedBox(height: xl);
}
