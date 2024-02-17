class RemoteConfigModel {
  late bool updateRequired;
  late bool optional;
  late bool optionalIos;
  late int versionCode;
  late int versionCodeIos;
  late String link;
  late String linkIos;

  RemoteConfigModel(
      {this.updateRequired = false,
        this.optional = false,
        this.optionalIos = false,
        required this.versionCode,
        required this.versionCodeIos,
        required this.link,
        required this.linkIos});

  RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    updateRequired = json['updateRequired'];
    optional = json['optional'];
    optionalIos = json['optionalIos'];
    versionCode = json['versionCode'];
    versionCodeIos = json['versionCodeIos'];
    link = json['link'];
    linkIos = json['link_ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updateRequired'] = updateRequired;
    data['optional'] = optional;
    data['optionalIos'] = optionalIos;
    data['versionCode'] = versionCode;
    data['versionCodeIos'] = versionCodeIos;
    data['link'] = link;
    data['link_ios'] = linkIos;
    return data;
  }
}
