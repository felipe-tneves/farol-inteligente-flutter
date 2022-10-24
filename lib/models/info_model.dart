class InfoModel {
  String? clima;
  String? data;
  String? endereco;
  String? hora;
  int? id;
  int? qtd;

  InfoModel({this.clima, this.data, this.endereco, this.hora, this.id, this.qtd});

  InfoModel.fromJson(Map<String, dynamic> json) {
    clima = json['clima'];
    data = json['data'];
    endereco = json['endereco'];
    hora = json['hora'];
    id = json['id'];
    qtd = json['qtd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clima'] = this.clima;
    data['data'] = this.data;
    data['endereco'] = this.endereco;
    data['hora'] = this.hora;
    data['id'] = this.id;
    data['qtd'] = this.qtd;
    return data;
  }
}
