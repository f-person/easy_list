import 'package:scoped_model/scoped_model.dart';

import './user.dart';
import './products.dart';

class MainModel extends Model with UserModel, ProductsModel {}
