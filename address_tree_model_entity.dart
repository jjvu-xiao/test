import 'package:fenggomall/generated/json/base/json_convert_content.dart';

class AddressTreeModelEntity with JsonConvert<AddressTreeModelEntity> {
	List<AddressTreeModelChild> childs;
	String id;
	String name;
}

class AddressTreeModelChild with JsonConvert<AddressTreeModelChild> {
	List<AddressTreeModelChildsChild> childs;
	String id;
	String name;
}

class AddressTreeModelChildsChild with JsonConvert<AddressTreeModelChildsChild> {
	String id;
	String name;
}
