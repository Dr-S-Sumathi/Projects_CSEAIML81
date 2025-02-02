import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
const String apiUrl = 'http://35.154.71.152:5000';
const String nodeUrl = 'http://192.168.106.69:80';

const String cancerApiUrl = "http://192.168.94.213:5000";
const String vidStreamUrl = "192.168.94.56:8000";

Future <bool> loginUser(String email, String password) async{
  var response = await http.put(Uri.parse(apiUrl+'/user/login'),
      body: {'email': email, 'password': password});
  if(response.statusCode == 200)
  {
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['valid'] == 'true') {
      return true;
    }
    else
    {
      return false;
    }
  }
  else
  {
    return false;
  }
}

void motorTiming(int time) async{
  final response = await http.post(
    Uri.parse(nodeUrl+'/motor/on'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'delay': '$time',
    },
  );
}

// I KNOW YOU LOVE SOMEONE RIGHT?

Future <bool> registerUser(String email, String password, String username) async{
  var response = await http.put(Uri.parse(apiUrl+'/user/register'),
      body: {'email': email, 'password': password, 'username':username});

  if(response.statusCode == 200)
  {
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['valid'] == 'true') {
      return true;
    }
    else
    {
      return false;
    }
  }
  else
  {
    return false;
  }
}

//HEY BRO I CHANGED YOUR CODE

Future<String> getUsername(String email) async{
  var response = await http.put(Uri.parse(apiUrl+'/user/info'),
      body : {'email':email});

  if(response.statusCode == 200)
  {
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['username'].toString().isNotEmpty)
    {
      return jsonResponse['username'];
    }
  }
  return '';

}

// HEY BRO I FOUND SOME ERROR


Future<String> detectPlant(String imagePath) async {
  var imageFile = File(imagePath);
  var stream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();
  var uri = Uri.parse(apiUrl+'/plant/detect');
  var request = http.MultipartRequest('POST', uri);
  var multipartFile = http.MultipartFile('image', stream, length, filename: path.basename(imageFile.path));
  request.files.add(multipartFile);
  var response = await request.send();
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(await response.stream.bytesToString());
    return jsonResponse['name'];
  }
  return '';
}

Future<String> detectDisease(String imagePath) async {
  var imageFile = File(imagePath);
  var stream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();
  var uri = Uri.parse(apiUrl+'/disease/detect');
  var request = http.MultipartRequest('POST', uri);
  var multipartFile = http.MultipartFile('image', stream, length, filename: path.basename(imageFile.path));
  request.files.add(multipartFile);
  var response = await request.send();
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(await response.stream.bytesToString());
    return jsonResponse['disease'];
  }
  return '';
}
//HEY BRO I AM LOOKING AT YOU //