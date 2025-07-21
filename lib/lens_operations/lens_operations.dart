class LensOperations{
  String? brand;
  String? purchased_date;
  String? expiry_date;

  List<dynamic> lens = [
    {

    }
  ];

  List<dynamic> recentLogs = [
    {"date":"14-1-2025", "hours": "9"},
    {"date": "16-1-2025", "hours": "9"},
    {"date": "30-1-2025", "hours": "9"},
    {"date": "20-2-2025", "hours": "5"},
    {"date": "21-2-2025", "hours": "9"},
    {"date": "22-2-2025", "hours": "9"},
    {"date": "23-2-2025", "hours": "12"},
    {"date": "30-3-2025", "hours": "15"},
    {"date": "28-6-2025", "hours": "5"},
  ];

  List<dynamic> getLens(){
    return lens;
  }
  List<dynamic> getRecentRecords(){
    return recentLogs;
  }

  void addLens({String? bName, String? pDate , String? eDate}){
    lens.add({
      "brandName" : bName,
      "PurchasedDate" : pDate,
      "ExpiryDate" : eDate
    });
  }

  void addRecentRecords({String? date, String? hours}){
    recentLogs.add({"date": date, "hours": hours},);
  }

  void editRecentLogs(int index , String? date, String? hour){
    if(recentLogs.contains(recentLogs[index])){
      recentLogs[index] = {"date": date, "hours": hour};
    }
  }

  void deleteRecentLogs(int index){
    if(recentLogs.contains(recentLogs[index])){
      recentLogs.removeAt(index);
    }
  }
}