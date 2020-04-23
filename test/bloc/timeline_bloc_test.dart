import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polis/bloc/blocs.dart';
import 'package:polis/core/constants.dart';
import 'package:polis/model/despesa_model.dart';
import 'package:tuple/tuple.dart';

import '../mock.dart';

void main() {
  group('TimelineBloc tests', () {
    TimelineBloc timelineBloc;
    MockTimelineRepository mockTimelineRepository;
    var timelineStream = Stream.fromIterable([0, 3, 5]);
    MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      mockTimelineRepository = MockTimelineRepository();
      mockDocumentSnapshot = MockDocumentSnapshot();
      timelineBloc = TimelineBloc(
        repository: mockTimelineRepository,
      );
      timelineStream = Stream.value(0);
    });

    test('asserts', () {
      expect(
          () => TimelineBloc(
                repository: null,
              ),
          throwsAssertionError);
    });

    test('''Expects InitialTimelineState to be the initial state''', () {
      expect(timelineBloc.state, equals(InitialTimelineState()));
    });

    blocTest(
      '''Expects [LoadingTimeline, TimelineUpdated]''',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(Tuple2([], mockDocumentSnapshot)),
        );
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        timelineBloc.add(
          UpdateTimelineActivitiesCount(count: 0),
        );
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        TimelineUpdated(activities: [], postsCount: 0, updatesCount: 0),
      ],
    );

    blocTest(
      'set isTimelineFetchedOnce flag to true after the first run',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(Tuple2([], mockDocumentSnapshot)),
        );
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        timelineBloc.add(UpdateTimelineActivitiesCount(count: 0));
        timelineBloc.add(NotifyTimelineFetchedOnce());
        timelineBloc.add(FetchUserTimeline('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(2);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        TimelineUpdated(activities: [], postsCount: 0, updatesCount: 0),
        LoadingTimeline(),
      ],
    );

    blocTest(
      'set isTimelineFetchedOnce flag to true before the first run',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(Tuple2([], mockDocumentSnapshot)),
        );
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(NotifyTimelineFetchedOnce());
        timelineBloc.add(FetchUserTimeline('1'));
        timelineBloc.add(UpdateTimelineActivitiesCount(count: 0));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        TimelineUpdated(activities: [], postsCount: 0, updatesCount: 0),
      ],
    );

    blocTest(
      '''Expects [FetchTimelineFailed] when getUserTimeline failed''',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenThrow(Exception());
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
      },
      expect: [
        LoadingTimeline(),
        FetchTimelineFailed(),
      ],
    );

    blocTest(
      '''Expects [FetchTimelineFailed] when getTimelineFirstPosts failed''',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenThrow(Exception());
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        FetchTimelineFailed(),
      ],
    );

    blocTest(
      '''Expects [LoadingTimeline, TimelineUpdated, UpdateTimeline] when fetch more posts''',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(
            Tuple2([DespesaModel(id: '1')], mockDocumentSnapshot),
          ),
        );
        when(mockTimelineRepository.getMorePosts(
                '1', kTimelinePageSize, mockDocumentSnapshot))
            .thenAnswer(
          (_) => Future.value(
            Tuple2([DespesaModel(id: '2'), DespesaModel(id: '3')],
                mockDocumentSnapshot),
          ),
        );
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        timelineBloc.add(UpdateTimelineActivitiesCount(count: 0));
        timelineBloc.add(FetchMorePosts('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
        verify(mockTimelineRepository.getMorePosts(
                '1', kTimelinePageSize, mockDocumentSnapshot))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        isA<TimelineUpdated>(),
        TimelineUpdated(
          activities: [
            DespesaModel(id: '1'),
            DespesaModel(id: '2'),
            DespesaModel(id: '3')
          ],
          postsCount: 3,
          updatesCount: 0,
        ),
      ],
    );

    blocTest(
      '''Expects [LoadingTimeline, TimelineUpdated, FetchTimelineFailed] when fetch more posts failed''',
      build: () async {
        when(mockTimelineRepository.getNewActivitiesCounter('1'))
            .thenAnswer((_) => timelineStream);
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(
            Tuple2([DespesaModel(id: '1')], mockDocumentSnapshot),
          ),
        );
        when(mockTimelineRepository.getMorePosts(
                '1', kTimelinePageSize, mockDocumentSnapshot))
            .thenThrow(Exception());
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(FetchUserTimeline('1'));
        timelineBloc.add(UpdateTimelineActivitiesCount(count: 0));
        timelineBloc.add(FetchMorePosts('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getNewActivitiesCounter('1')).called(1);
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
        verify(mockTimelineRepository.getMorePosts(
                '1', kTimelinePageSize, mockDocumentSnapshot))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        isA<TimelineUpdated>(),
        FetchTimelineFailed(),
      ],
    );

    blocTest(
      '''Expects [LoadingTimeline, TimelineUpdated] when reload timeline is added''',
      build: () async {
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenAnswer(
          (_) => Future.value(
            Tuple2([DespesaModel(id: '1')], mockDocumentSnapshot),
          ),
        );
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(ReloadTimeline('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        TimelineUpdated(
          activities: [
            DespesaModel(id: '1'),
          ],
          postsCount: 1,
          updatesCount: 0,
        ),
      ],
    );

    blocTest(
      '''Expects [LoadingTimeline, FetchTimelineFailed] when reload timeline throws exception''',
      build: () async {
        when(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .thenThrow(Exception());
        return timelineBloc;
      },
      act: (timelineBloc) {
        timelineBloc.add(ReloadTimeline('1'));
        return;
      },
      verify: (timelineBloc) async {
        verify(mockTimelineRepository.getTimelineFirstPosts(
                '1', kTimelinePageSize))
            .called(1);
      },
      expect: [
        LoadingTimeline(),
        FetchTimelineFailed(),
      ],
    );
  });
}
