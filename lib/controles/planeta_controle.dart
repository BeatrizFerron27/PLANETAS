import 'package:myapp/modelos/planetas.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd == null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(caminho, version: 1, onCreate: _criaBD);
  }

  Future<void> _criaBD(Database bd, int versao) async {
    const sql = '''
CREATE TABLE planetas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  tamanho REAL NOT NULL,
  distancia REAL NOT NULL,
  apelido TEXT
);
 ''';
    await bd.execute(sql);
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((map) => Planeta.fromMap(map)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('Planetas', planeta.toMap());
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete('Planetas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }
}
