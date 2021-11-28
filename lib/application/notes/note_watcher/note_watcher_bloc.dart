import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:try_ddd/domain/notes/i_note_repository.dart';
import 'package:try_ddd/domain/notes/note.dart';
import 'package:try_ddd/domain/notes/note_failure.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  NoteWatcherBloc(
    this._noteRepository,
  ) : super(const NoteWatcherState.initial()) {
    on<WatchAllStarted>(_onWatchAllStarted);
    on<WatchUncompletedStarted>(_onWatchUncompletedStarted);
    on<NotesReceived>(_onNotesReceived);
  }

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  // @override
  // Stream<NoteWatcherState> mapEventToState(
  //   NoteWatcherEvent event,
  // ) async* {
  //   yield* event.map(
  //     watchAllStarted: (e) async* {
  //       yield const NoteWatcherState.loadInProgress();
  //       await _noteStreamSubscription?.cancel();
  //       _noteStreamSubscription = _noteRepository.watchAll().listen(
  //             (failureOrNotes) =>
  //                 add(NoteWatcherEvent.notesReceived(failureOrNotes)),
  //           );
  //     },
  //     watchUncompletedStarted: (e) async* {
  //       yield const NoteWatcherState.loadInProgress();
  //       await _noteStreamSubscription?.cancel();
  //       _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
  //             (failureOrNotes) =>
  //                 add(NoteWatcherEvent.notesReceived(failureOrNotes)),
  //           );
  //     },
  //     notesReceived: (e) async* {
  //       yield e.failureOrNotes.fold(
  //         (f) => NoteWatcherState.loadFailure(f),
  //         (notes) => NoteWatcherState.loadSuccess(notes),
  //       );
  //     },
  //   );
  // }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onWatchAllStarted(
      WatchAllStarted event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchAll().listen(
          (failureOrNotes) =>
              add(NoteWatcherEvent.notesReceived(failureOrNotes)),
        );
  }

  FutureOr<void> _onWatchUncompletedStarted(
      WatchUncompletedStarted event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
          (failureOrNotes) =>
              add(NoteWatcherEvent.notesReceived(failureOrNotes)),
        );
  }

  FutureOr<void> _onNotesReceived(
      NotesReceived event, Emitter<NoteWatcherState> emit) {
    emit(event.failureOrNotes.fold(
      (f) => NoteWatcherState.loadFailure(f),
      (notes) => NoteWatcherState.loadSuccess(notes),
    ));
  }
}
