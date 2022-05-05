class GameSettings{
  final bool withAI;
  final int mafiaCount;
  final bool lastWordForKilled;

  GameSettings({required this.mafiaCount, this.lastWordForKilled = false, this.withAI = false});
}