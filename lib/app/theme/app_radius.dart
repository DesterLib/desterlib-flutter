import 'package:flutter/material.dart';

class AppRadius {
  static const double none = 0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;

  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusXXXL = BorderRadius.all(
    Radius.circular(xxxl),
  );
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );

  static const BorderRadius radiusTopSM = BorderRadius.vertical(
    top: Radius.circular(sm),
  );
  static const BorderRadius radiusTopMD = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius radiusTopLG = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
  static const BorderRadius radiusTopXL = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
  static const BorderRadius radiusTopXXL = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );

  static const BorderRadius radiusBottomSM = BorderRadius.vertical(
    bottom: Radius.circular(sm),
  );
  static const BorderRadius radiusBottomMD = BorderRadius.vertical(
    bottom: Radius.circular(md),
  );
  static const BorderRadius radiusBottomLG = BorderRadius.vertical(
    bottom: Radius.circular(lg),
  );
  static const BorderRadius radiusBottomXL = BorderRadius.vertical(
    bottom: Radius.circular(xl),
  );
  static const BorderRadius radiusBottomXXL = BorderRadius.vertical(
    bottom: Radius.circular(xxl),
  );
}
