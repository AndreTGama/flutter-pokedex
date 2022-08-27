import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeAPI.dart';
import 'package:http/http.dart' as http;
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  late PokeAPI pokeAPI;

  @action
  fetchPokemonList() {
    loadPokeAPI().then((pokeList) {
      pokeAPI = pokeList;
    });
  }

  Future<PokeAPI> loadPokeAPI() async {
    final response = await http.get(Uri.parse(ConstsAPI.pokeApiURL));
    var decodeJson = jsonDecode(response.body);
    return PokeAPI.fromJson(decodeJson);
  }
}
