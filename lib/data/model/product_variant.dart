import 'package:apple_shop_application/data/model/variant.dart';
import 'package:apple_shop_application/data/model/variant_type.dart';

class ProductVariant {
  VariantType variantType;
  List<Variant> variantList;

  ProductVariant(this.variantType, this.variantList);
}
