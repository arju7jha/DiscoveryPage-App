import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> items = [];
  int page = 1;
  int limit = 10;
  bool _isLoading = false;
  bool _isConnected = true;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchData();
    _initializeConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _initializeConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
    });
    if (_isConnected) {
      _refreshData();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!_isLoading && items.length < limit && _isConnected) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.get(Uri.parse(
            'https://api-stg.together.buzz/mocks/discovery?page=$page&limit=$limit'));

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final List<dynamic> newData = responseData['data'];

          if (newData.isNotEmpty) {
            setState(() {
              items.addAll(newData);
              page++; // Increment page for next pagination
            });
          } else {
            // Stop loading more items if the API response is empty
            _isLoading = false;
          }
        } else {
          // Handle API error
          throw Exception('API Error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle network error
        print('Error: $e');
        const snackBar = SnackBar(
            content: Text(
                'Network error occurred. Please check your internet connection.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        // Ensure isLoading is set to false after completing the operation
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Discovery Page', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 25),),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.black,
            iconSize: 30,
            onPressed: () {
              _refreshData();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: _isConnected
          ? RefreshIndicator(
              onRefresh: _refreshData,
              child: _buildDiscoveryPage(),
            )
          : const Text(
              'No internet connection. Please check your internet settings.'),
    );
  }

  Widget _buildDiscoveryPage() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return _buildCard(item);
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildCard(dynamic item) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: _buildImage(item['image_url']),
          title: Text(item['title'] ?? 'No Title'),
          subtitle: Text(item['description'] ?? 'No Description'),
          onTap: () {
            // Add functionality to handle card tap
          },
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.image);
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      items.clear();
      page = 1;
    });
    await _fetchData();
  }
}
