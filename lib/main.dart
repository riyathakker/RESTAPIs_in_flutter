import 'package:flutter/material.dart'; // flutter widgets
import 'package:http/http.dart' as http; //http req
import 'package:dio/dio.dart'; //more advanced http client
import 'dart:convert'; //encoding decoding

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter HTTP Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/todos?_limit=2';
  final String githubApiUrl = 'https://api.github.com/users/flutter';
  String httpData = '';
  String exchangeData = '';
  String dioData = '';
  String githubData = '';
  String joke = '';
  
  Future<void> fetchDataWithHttp() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      setState(() {
        httpData = response.body;
        dioData = '';
        githubData = '';
        joke = '';
        exchangeData = '';
      });
    } catch (e) {
      print('HTTP Error: $e');
    }
  }

  Future<void> fetchGitHubData() async {
    try {
      final response = await http.get(Uri.parse(githubApiUrl));
      setState(() {
        githubData = response.body;
        httpData = '';
        dioData = '';
        joke = '';
        exchangeData = '';
      });
    } catch (e) {
      print('GitHub API Error: $e');
    }
  }

  Future<void> fetchDataWithDio() async {
    try {
      final dio = Dio();
      final response = await dio.get(apiUrl);
      setState(() {
        dioData = response.data.toString();
        httpData = '';
        githubData = '';
        joke = '';
        exchangeData = '';
      });
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  Future<void> fetchJoke() async {
    try {
      final response = await http.get(Uri.parse('https://icanhazdadjoke.com/'), headers: {
        'Accept': 'application/json', // Specify JSON response
      });
      if (response.statusCode == 200) {
        setState(() {
          joke = json.decode(response.body)['joke'];
          httpData = '';
          dioData = '';
          githubData = '';
          exchangeData = '';
        });
      } else {
        print('Failed to load joke: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching joke: $e');
    }
  }
  Future<void> fetchExchangeRate() async {
  final dio = Dio();
  final response = await dio.get('https://api.exchangerate-api.com/v4/latest/USD');
  if (response.statusCode == 200) {
    setState(() {
      exchangeData = response.data.toString();
      httpData = '';
      githubData = '';
      joke = '';
      dioData='';
    });
  } else {
    print('Failed to fetch exchange rates: ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter HTTP Demo'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: fetchDataWithHttp,
                child: Text('Fetch Data with http'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0), // Make buttons square
                  ),
                  side: BorderSide(color: Colors.black), // Add border color
                ),
              ),
              SizedBox(height: 16), // Add space between buttons
              OutlinedButton(
                onPressed: fetchDataWithDio,
                child: Text('Fetch Data with dio'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0), // Make buttons square
                  ),
                  side: BorderSide(color: Colors.black), // Add border color
                ),
              ),
              SizedBox(height: 16), // Add space between buttons
              OutlinedButton(
                onPressed: fetchGitHubData,
                child: Text('Fetch Data from GitHub API'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0), // Make buttons square
                  ),
                  side: BorderSide(color: Colors.black), // Add border color
                ),
              ),
              SizedBox(height: 16), // Add space between buttons
              OutlinedButton(
                onPressed: fetchJoke,
                child: Text('Fetch Joke'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0), // Make buttons square
                  ),
                  side: BorderSide(color: Colors.black), // Add border color
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                  onPressed: fetchExchangeRate,
                  child: Text('Fetch Exchange Rate'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0), // Make buttons square
                    ),
                    side: BorderSide(color: Colors.black), // Add border color
                ),
              ),

              SizedBox(height: 16), // Add space between buttons
              if (httpData.isNotEmpty) Text('HTTP Data: $httpData'),
              if (dioData.isNotEmpty) Text('Dio Data: $dioData'),
              if (githubData.isNotEmpty) Text('GitHub Data: $githubData'),
              if (joke.isNotEmpty) Text('Joke: $joke'),
              if (exchangeData.isNotEmpty) Text('Exchange Rate: $exchangeData'),
            ],
          ),
        ),
      ),
    );
  }
}
