import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' show ProviderNotFoundException;

/// Wraps [child] in a `BlocProvider.value` for an existing [C] from an
/// ancestor, or creates a fresh one with [create] if none is provided.
///
/// This lets the same page widget be reused as a standalone navigation
/// destination AND as a tab whose cubit is owned higher up in the tree
/// (for cross-tab refresh).
class InheritedOrNewBloc<C extends BlocBase<dynamic>> extends StatelessWidget {
  const InheritedOrNewBloc({
    super.key,
    required this.create,
    required this.child,
  });

  final C Function() create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    try {
      final existing = context.read<C>();
      return BlocProvider<C>.value(value: existing, child: child);
    } on ProviderNotFoundException {
      return BlocProvider<C>(create: (_) => create(), child: child);
    }
  }
}
