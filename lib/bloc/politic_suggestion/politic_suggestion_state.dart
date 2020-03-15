import 'package:equatable/equatable.dart';

import '../../model/politico_model.dart';

abstract class PoliticSuggestionState extends Equatable {
  const PoliticSuggestionState();
}

class InitialPoliticSuggestionState extends PoliticSuggestionState {
  @override
  List<Object> get props => [];
}

class FetchSuggestedPoliticsSuccess extends PoliticSuggestionState {
  FetchSuggestedPoliticsSuccess(this.politicos);

  final List<PoliticoModel> politicos;

  @override
  List<Object> get props => [politicos];
}

class FetchSuggestedPoliticsFailed extends PoliticSuggestionState {
  @override
  List<Object> get props => [];
}

class ChangedPoliticsFollowingStatus extends PoliticSuggestionState {
  ChangedPoliticsFollowingStatus(this.politico, {this.isFollowing});

  final PoliticoModel politico;
  final bool isFollowing;

  @override
  List<Object> get props => [politico, isFollowing];
}

class LoadingFetch extends PoliticSuggestionState {
  @override
  List<Object> get props => [];
}