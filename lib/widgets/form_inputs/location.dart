import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../helpers/ensure-visible.dart';
import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      getStaticMap(widget.product.location.address);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    if (widget.product == null) {
      final Uri uri = Uri.https(
        'eu1.locationiq.com',
        'v1/search.php',
        {'key': 'f57778666f47cc', 'q': address, 'format': 'json'},
      );
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);

      final formattedAddress = decodedResponse[0]['display_name'];
      _locationData = LocationData(
        address: formattedAddress,
        latitude: double.parse(decodedResponse[0]['lat']),
        longitude: double.parse(decodedResponse[0]['lon']),
      );
    } else {
      _locationData = widget.product.location;
    }

    final Uri staticMapUri = Uri.https('maps.locationiq.com', '/v2/staticmap', {
      'key': 'f57778666f47cc',
      'size': '500x300',
      'markers':
          'size:large|icon:large-red-cutout|${_locationData.latitude},${_locationData.longitude}',
    });

    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            validator: (String value) {
              if (_locationData == null || value.isEmpty) {
                return 'No valid location found.';
              }
            },
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri.toString())
      ],
    );
  }
}
