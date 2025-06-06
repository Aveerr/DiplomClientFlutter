import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesState {
  final String companyName;
  final bool isLoading;

  const FavoritesState({
    this.companyName = '',
    this.isLoading = false,
  });

  FavoritesState copyWith({String? companyName, bool? isLoading}) {
    return FavoritesState(
      companyName: companyName ?? this.companyName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class FavoritesEvent {
  const FavoritesEvent();
}

class InitializeFavoritesEvent extends FavoritesEvent {
  const InitializeFavoritesEvent();
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<InitializeFavoritesEvent>(_handleInitiailizeFavoritesEvent);

    add(const InitializeFavoritesEvent());
  }

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializeFavoritesEvent event, Emitter<FavoritesState> emit) async {}
}
