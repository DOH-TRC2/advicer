import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/use_cases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'advicer_event.dart';
part 'advicer_state.dart';

const String generalFailureMessage='An unknown Error Occured, Please try again';
const String serverFailureMessage='Cannot Connect to Server, Please Check your Connection and Try Again';
const String cacheFailureMessage ='Something while Transporting Data, Please check your Connection and Try Again';

class AdvicerBloc extends Bloc<AdvicerEvent, AdvicerState> {
  AdvicerBloc() : super(AdvicerInitial()) {
    final AdviceUseCases adviceUseCases = AdviceUseCases();

    on<AdviceRequestedEvent>((event, emit) async {
      emit(AdvicerStateLoading());
      final adviceOrFailure = await adviceUseCases.getAdvice();
      adviceOrFailure.fold(
          (failure) => emit(AdvicerStateError(message:_mapFailureToMessage(failure))),
          (advice) => emit(AdvicerStateLoaded(advice: advice.advice)));
    });

    
  }
  String _mapFailureToMessage(Failure failure) {
      switch (failure.runtimeType) {
        case ServerFailure:
          return serverFailureMessage;
        case CacheFailure:
          return cacheFailureMessage;
        default:
          return generalFailureMessage;
      }
    }
}
