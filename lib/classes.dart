
class GlobalPieData{
  int confirmed, deaths, recovered;
  GlobalPieData(this.confirmed,this.recovered,this.deaths);
}

class AvailableData{

  Map national;
  GlobalPieData globalPieData;
  Map globalLineData;

  AvailableData(this.national,this.globalPieData,this.globalLineData);
}