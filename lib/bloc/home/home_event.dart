abstract class HomeEvent {}

class HomeGetInitilzeData implements HomeEvent {}

class HomeSearchProductsEvent extends HomeEvent {
  String keywordVale;

  HomeSearchProductsEvent(this.keywordVale);
}
