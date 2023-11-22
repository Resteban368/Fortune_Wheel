import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'board_view.dart';
import 'models/model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;

  late AnimationController _ctrl;
  late Animation _ani;

  List<Luck> _items = [
    Luck("apple", Colors.accents[0]),
    Luck("raspberry", Colors.accents[2]),
    Luck("grapes", Colors.accents[4]),
    Luck("fruit", Colors.accents[6]),
    Luck("milk", Colors.accents[8]),
    Luck("salad", Colors.accents[10]),
    Luck("cheese", Colors.accents[12]),
    Luck("carrot", Colors.accents[14]),
  ];

  //lista de resultados
  List<String> _result = [];

  @override
  void initState() {
    super.initState();
    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: 
        Colors.red,
        onPressed: () {
          setState(() {
            _result.clear();
          });
        },
        child: Icon(Icons.refresh),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red, Colors.amber.withOpacity(0.8)])),
        child: AnimatedBuilder(
            animation: _ani,
            builder: (context, child) {
              final _value = _ani.value;
              final _angle = _value * this._angle;
              return Column(
                children: [
                  const SizedBox(height: 90),
                  Text(
                    "Spin Wheel",
                    style: TextStyle(
                        fontSize: 32.0, 
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: size.width,
                    height: size.height * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        BoardView(
                            items: _items, current: _current, angle: _angle),
                        _buildGo(),
                      ],
                    ),
                  ),
                  _buildResult(_value),
                  Text(
                    "Result",
                    style: TextStyle(
                        fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BounceInDown(
                          duration: Duration(milliseconds: 500),
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(_result[index],
                                      height: 50, width: 50),
                            ),
                          ),
                        );
                      },
                      itemCount: _result.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            "GO",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
    );
  }


  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;

      // Avanzar la animación
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();

        // Calcular el índice y agregar el resultado a la lista
        var _index = _calIndex(_current);
        String _asset = _items[_index].asset;

        // Agregar el resultado solo después de que la animación ha terminado
        setState(() {
          _result.add(_asset);
        });
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    String _asset = _items[_index].asset;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Image.asset(_asset, height: 80, width: 80),
    );
  }
}
