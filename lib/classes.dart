
class Global{
  int confirmed, deaths, recovered;
  Global(this.confirmed,this.recovered,this.deaths);
}

class AvailableData{

  Map national;
  Global global;
  AvailableData(this.national,this.global);
}