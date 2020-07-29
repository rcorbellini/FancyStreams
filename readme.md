
# The Fancy streams

 With the idea of empowering the streams, this lib was created, making it super ultra easy to use in any project, it makes a perfect pair with the Bloc architecture, but it is modern and independent and can be used in any other context. 

Not recommend it for those who are learning to work with streams, because of the ease that this lib provides if you are starting you will not learn the basics of using streams.

## Let's hands on code:


Traditional Way - Working on events/State
---
The boring and traditonal way to use streams is almost like that, you need a controller,sink and stream, for each stream that you will work on and you will need close/cancel every necessary object.
_YourBloc_
``` dart
class HomeBloc  {
  BehaviorSubject<HomeEvent> _controller =  BehaviorSubject();
  Function(HomeEvent) get dispatchEvent => _controller.sink.add;
  Stream<HomeEvent> get homeEvents$ => _controller.stream;
  StreamSubscription subscription;
  
  HomeBloc(){
    subscription = homeEvents$.listen(_handleEvents);
    dispatchEvent(LoadTalks());
  }
  
  dispose(){
    _controller.close();
    subscription?.cancel();

  }
}
```

_yourWidget_
``` dart
 StreamBuilder<HomeEvent>(
                    stream: homeBloc.homeEvents$,
                    builder:...);                 
```

When you are working on a form with 10 fields and every field need a stream, will be more than 30 lines of boilerplate, and everyone HATES boilerplate.


Fancy Way - Working on events/State
---

Now i will show you a power of fancy streams:

_YourBloc_
``` dart
class HomeBloc extends Disposable {

  HomeBloc() {    
    listenOn<HomeEvent>(_handleEvents);
    dispatchOn<HomeEvent>(LoadTalks());
  }
}
```
_the [Disposable.dispose] function already call [cleanAll] of power streams._

_yourWidget_
``` dart
 StreamBuilder<HomeEvent>(
                    stream:  homeBloc.streamOf<HomeEvent>(),
                    builder:...);                 
```

Traditional Way - Working on Forms
---

Fancy Way - Working on forms
---
