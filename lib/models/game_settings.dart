class GameSettings{
  final bool withAI;
  final int mafiaCount;
  final bool lastWordForKilled;

  GameSettings({required this.mafiaCount, this.lastWordForKilled = false, this.withAI = false});

   Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['withAI'] = withAI;
    data['mafiaCount'] = mafiaCount;
    data['lastWordForKilled'] = lastWordForKilled;
    return data;
  }

  factory GameSettings.fromJson(Map<String, dynamic> json){
    return GameSettings(
      mafiaCount: json['mafiaCount'],
      withAI: json['withAI'],
      lastWordForKilled: json['lastWordForKilled'],
    );
  }

}