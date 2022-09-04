import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/home_page/widgets/app_bar_home.dart';
import 'package:pokedex/pages/home_page/widgets/poke_item.dart';
import 'package:pokedex/store/pokeapi_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore? pokeApiStore;
  @override
  void initState() {
    super.initState();
    pokeApiStore = PokeApiStore();
    pokeApiStore?.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusWidth = MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: -(240 / 4.7),
              left: screenWidth - (240 / 1.6),
              child: Opacity(
                child: Image.asset(
                  ConstsApp.darkPokeBall,
                  height: 240,
                  width: 240,
                ),
                opacity: 0.1,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: statusWidth,
                  ),
                  AppBarHome(),
                  Expanded(
                      child: Container(
                          child: Observer(
                    name: 'ListaHomePage',
                    builder: (BuildContext context) {
                      PokeAPI? _pokeApi = pokeApiStore?.pokeAPI;
                      return (_pokeApi != null)
                          ? AnimationLimiter(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(12),
                                addAutomaticKeepAlives: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: _pokeApi.pokemon?.length,
                                itemBuilder: (context, index) {
                                  Pokemon pokemon =
                                      pokeApiStore?.getPokemon(index);
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                      child: GestureDetector(
                                        child: GestureDetector(
                                          child: PokeItem(
                                              index: index,
                                              name: pokemon.name,
                                              image: pokeApiStore
                                                  ?.getImage(pokemon.num)),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    Container() /*PokeDetailPage(index: index)*/,
                                                fullscreenDialog: true,
                                              ));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ))),
                ],
              ),
            ),
          ],
        ));
  }
}
