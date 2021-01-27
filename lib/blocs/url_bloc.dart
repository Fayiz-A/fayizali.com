import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlEvent {}

class UrlLaunchEvent extends UrlEvent {
  final String url;
  UrlLaunchEvent({@required this.url});
}

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(UrlLaunchInitialState());

  UrlLaunchInitialState get initialState => UrlLaunchInitialState();

  @override
  Stream<UrlState> mapEventToState(UrlEvent event) async* {
    if(event is UrlLaunchEvent) {
      yield* launchUrl(url: event.url);
    } else {
      yield UrlLaunchInitialState();
    }
  }

}

Stream<UrlState> launchUrl({@required String url}) async* {
  try {
    if(await canLaunch(url)) {
      await launch(url);
      yield UrlLaunchedSuccessfully();
    } else {
      yield UrlCoudntBeLaunched();
    }
  } catch(e) {
    debugPrint('Error occurred in launching url $url: $e');
    yield UrlCoudntBeLaunched();
  }
}

abstract class UrlState {

}

class UrlLaunchInitialState extends UrlState {}

class UrlLaunchedSuccessfully extends UrlState {}

class UrlCoudntBeLaunched extends UrlState {}