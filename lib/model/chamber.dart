class Chamber {

  int id;
  String name;
  String address;

  Chamber({this.id, this.name, this.address});

  Chamber.fromJson(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    name =  json['name'] == null ? "" : json['name'];
    address =  json['address'] == null ? "" : json['address'];
  }

  toJson() {

    return {
      "name" : name == null ? "" : name,
      "address" : address == null ? "" : address
    };
  }
}


class Chambers {

  List<Chamber> list;

  Chambers({this.list});

  Chambers.fromJson(Map<String, dynamic> json) {

    list = List();

    if(json['chamber_list'] != null) {

      json['chamber_list'].forEach((chamber) {

        list.add(Chamber.fromJson(chamber));
      });
    }
  }
}