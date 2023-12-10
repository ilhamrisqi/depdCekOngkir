part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Costs> calculateCosts = [];
  bool isLoading = false;
  bool dataReady = false;
  bool isFirstLoad = true;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provinceData;

  dynamic cityIdOrigin;
  dynamic cityIdDestination;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;

  dynamic PengirimanBarang;

  

  dynamic dataLength;

  TextEditingController beratbarang = TextEditingController();

  Future<List<Province>> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        prov = value;
        isLoading = false;
      });
    });
    return prov;
  }

  //function untuk ambil data city
  Future<List<City>> getCitys(var provinceId) async {
    dynamic city;
    await MasterDataService.getCitys(provinceId).then((value) {
      setState(() {
        city = value;
      });
    });
    return city;
  }

  //function untuk  ambil data cost
  Future<List<Costs>> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    try {
      List<Costs> costs = await MasterDataService.getCosts(
        originId,
        destinationId,
        weight,
        courier,
      );
      return costs;
    } catch (error) {
      print('Error fetching costs: $error');
      return []; 
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text("Pilih Jasa Pengiriman",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(width: 50.0),
                            Text("Berat",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // menampilkan list jasa pengiriman
                              Expanded(
                                flex: 2,
                                child: DropdownButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  value: PengirimanBarang,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  hint: const Text("Pilih Jasa Pengiriman"),
                                  isExpanded: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      PengirimanBarang = value;
                                    });
                                  },
                                  items: <String>[
                                    'JNE',
                                    'TIKI',
                                    'POS',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toLowerCase(),
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                  child: TextField(
                                    controller: beratbarang,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Berat Barang (gr)',
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Text("Origin",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            // Menampilkan list provinsi origin
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Menampilkan loading indicator jika data masih dimuat
                                    return UILoading.loading();
                                  } else if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceOrigin,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedProvinceOrigin == null
                                          ? const Text("Provinsi")
                                          : Text(
                                              selectedProvinceOrigin.province),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<Province>>(
                                              (Province valueProvince) {
                                        return DropdownMenuItem(
                                          value: valueProvince,
                                          child: Text(valueProvince.province
                                              .toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValueProvince) async {
                                        setState(() {
                                          selectedProvinceOrigin =
                                              newValueProvince;
                                          cityDataOrigin = getCitys(
                                            selectedProvinceOrigin.provinceId
                                                .toString(),
                                          );
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("Error fetching data");
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            // Menampilkan list kota origin
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return UILoading.loading();
                                  } 
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityOrigin,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: const TextStyle(color: Colors.black),
                                      hint: selectedCityOrigin == null
                                          ? const Text("Pilih Kota")
                                          : Text(selectedCityOrigin.cityName),
                                      items: snapshot.data
                                          !.map<DropdownMenuItem<City>>(
                                              (City valueCity) {
                                        return DropdownMenuItem(
                                          value: valueCity,
                                          child:
                                              Text(valueCity.cityName.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValueCity) {
                                        setState(() {
                                          selectedCityOrigin = newValueCity;
                                          cityIdOrigin =
                                              selectedCityOrigin.cityId;
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("Error fetching data");
                                  }
                                  return 
                                  DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                    isDense: false,
                                    hint: const Text("Pilih Kota"),
                                    disabledHint: const Text("Pilih Kota"),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                       
                        const Row(
                          children: [
                            Text("Destination",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            // menampilkan list provinsi
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceDestination,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedProvinceDestination == null
                                          ? const Text("Provinsi")
                                          : Text(selectedProvinceDestination
                                              .province),
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<Province>>(
                                              (Province itemProvince) {
                                        return DropdownMenuItem(
                                            value: itemProvince,
                                            child: Text(itemProvince.province
                                                .toString()));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedProvinceDestination = null;
                                          selectedProvinceDestination =
                                              newValue;
                                          cityDataDestination = getCitys(
                                              selectedProvinceDestination
                                                  .provinceId
                                                  .toString());
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                  );
                                },
                              ),
                            ),
                            
                            //show city list
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      isLoadingCityDestination) {
                                    return UILoading.loading();
                                  }
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityDestination,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedCityDestination == null
                                          ? const Text("Pilih Kota")
                                          : Text(
                                              selectedCityDestination.cityName),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<City>>(
                                              (City itemCity) {
                                        return DropdownMenuItem(
                                            value: itemCity,
                                            child: Text(
                                                itemCity.cityName.toString()));
                                      }).toList(),
                                      onChanged: (newItemCity) {
                                        setState(() {
                                          selectedCityDestination = newItemCity;
                                          cityIdDestination =
                                              selectedCityDestination.cityId;
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return 
                                  DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                    isDense: false,
                                    hint: const Text("Pilih Kota"),
                                    disabledHint: const Text("Pilih Kota"),
                                  );
                                  
                                },
                              ),
                            ),
                          ],
                        ),

                        Flexible(
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                     minimumSize: Size(200, 100),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    List<Costs> updatedCosts = await getCosts(
                                      selectedCityOrigin.cityId,
                                      selectedCityDestination.cityId,
                                      beratbarang.text,
                                      PengirimanBarang,
                                    );

                                    setState(() {
                                      calculateCosts = updatedCosts;
                                      isLoading = false;
                                    });
                                  },
                                  child: Text(
                                    "Cek Ongkir",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: calculateCosts.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("Data tidak ditemukan"),
                            )
                          : ListView.builder(
                              itemCount: calculateCosts.length,
                              itemBuilder: (context, index) {
                                return CardCost(calculateCosts[index]);
                              },
                            )),
                ),
              ],
            ),
          ),
          // show loading indicator
          isLoading == true ? UILoading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
