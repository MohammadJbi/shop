abstract class HomeEvent {}

class HomeGetInitilzeData implements HomeEvent {}

class HomeSearchWithQueryData extends HomeEvent {
  String query;

  HomeSearchWithQueryData(this.query);
}
