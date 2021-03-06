import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(const MiUbicacionState());

  late StreamSubscription<Position> _posicionSubscripcion;

  void iniciarSeguimiento() {
    _posicionSubscripcion = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((posicion) {
      final newLocation = LatLng(posicion.latitude, posicion.longitude);
      add(OnUbicacionCambio(newLocation));
    });
  }

  void cancelarSeguimiento() {
    _posicionSubscripcion.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    if (event is OnUbicacionCambio) {
      yield state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion);
    }
  }
}
