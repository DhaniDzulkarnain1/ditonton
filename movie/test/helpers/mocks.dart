import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockHttpClient extends Mock implements http.Client {}

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

class MockSearchMovies extends Mock implements SearchMovies {}

class MockNowPlayingMoviesBloc
    extends MockBloc<FetchNowPlayingMovies, MovieListState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc extends MockBloc<FetchPopularMovies, MovieListState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<FetchTopRatedMovies, MovieListState>
    implements TopRatedMoviesBloc {}

class MockWatchlistMoviesBloc
    extends MockBloc<FetchWatchlistMovies, MovieListState>
    implements WatchlistMoviesBloc {}

class MockMovieSearchBloc extends MockBloc<MovieSearchSubmitted, MovieListState>
    implements MovieSearchBloc {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}
