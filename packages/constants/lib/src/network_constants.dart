class NetworkConstants{
  //static const String SERVER_IP =  "http://192.168.178.35:5000"; //zuhause //"http://192.168.178.90:5000";//"https://aemn-0.herokuapp.com";

  //static const String SERVER_IP = "https://aemn-0.herokuapp.com";

  static const String SERVER_IP =  "http://10.0.0.126:5000";


  static const String APIKEY_PEXELS = "563492ad6f91700001000001a21feb8ede4d4bfbb7d4783e885b483f"; // https://www.pexels.com/api/new/
  static const String BASEURL_PEXELS = "https://api.pexels.com/v1/";

  @override
  List<Object> get props => [SERVER_IP, APIKEY_PEXELS, BASEURL_PEXELS];

}