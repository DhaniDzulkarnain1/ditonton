import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockTvSeriesRepository extends Mock implements TvSeriesRepository {}

class MockTvSeriesRemoteDataSource extends Mock
    implements TvSeriesRemoteDataSource {}

class MockTvSeriesLocalDataSource extends Mock
    implements TvSeriesLocalDataSource {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockHttpClient extends Mock implements http.Client {}

class MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTvSeries {}

class MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

class MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

class MockGetTvSeriesDetail extends Mock implements GetTvSeriesDetail {}

class MockGetTvSeriesRecommendations extends Mock
    implements GetTvSeriesRecommendations {}

class MockGetWatchlistStatusTvSeries extends Mock
    implements GetWatchlistStatusTvSeries {}

class MockSaveWatchlistTvSeries extends Mock implements SaveWatchlistTvSeries {}

class MockRemoveWatchlistTvSeries extends Mock
    implements RemoveWatchlistTvSeries {}

class MockGetWatchlistTvSeries extends Mock implements GetWatchlistTvSeries {}

class MockSearchTvSeries extends Mock implements SearchTvSeries {}

class MockGetSeasonDetails extends Mock implements GetSeasonDetails {}

class MockOnTheAirTvSeriesBloc
    extends MockBloc<FetchOnTheAirTvSeries, TvSeriesListState>
    implements OnTheAirTvSeriesBloc {}

class MockPopularTvSeriesBloc
    extends MockBloc<FetchPopularTvSeries, TvSeriesListState>
    implements PopularTvSeriesBloc {}

class MockTopRatedTvSeriesBloc
    extends MockBloc<FetchTopRatedTvSeries, TvSeriesListState>
    implements TopRatedTvSeriesBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<FetchWatchlistTvSeries, TvSeriesListState>
    implements WatchlistTvSeriesBloc {}

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchSubmitted, TvSeriesListState>
    implements TvSeriesSearchBloc {}

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class MockSeasonEpisodesBloc
    extends MockBloc<FetchSeasonEpisodes, SeasonEpisodesState>
    implements SeasonEpisodesBloc {}
