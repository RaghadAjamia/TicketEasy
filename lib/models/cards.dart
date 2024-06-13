class CCard {
  String Complex;
  String Status;
  String BusNumber;
  String Bus_Num;
  int Seats_Num;

  CCard({
    required this.Complex,
    required this.Status,
    required this.BusNumber,
    required this.Bus_Num,
    required this.Seats_Num,
  });

  String get _Complex => Complex;
  String get _Status => Status;
  String get _BusNumber => BusNumber;
    String get _Bus_Num => Bus_Num;
  int get _Seats_Num => Seats_Num;

}