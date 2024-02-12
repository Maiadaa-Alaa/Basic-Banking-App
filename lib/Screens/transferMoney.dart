import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:BasicBankingApp/Utils/constants.dart';
import 'package:BasicBankingApp/SQFLite/dbHandler.dart';
import 'package:BasicBankingApp/SQFLite/db_model.dart';
import 'package:BasicBankingApp/Utils/flutterToast.dart';
import 'package:BasicBankingApp/Utils/global.dart';

class TransferMoney extends StatefulWidget {
  const TransferMoney({Key? key}) : super(key: key);

  @override
  State<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  DBHelper? dbHelper;
  late Future<List<DBModel>> transferList;
  TextEditingController searchController = TextEditingController();
  TextEditingController controlTransfer = TextEditingController();

  List<DBModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    transferList = dbHelper!.getList();
  }

  void filterSearchResults(String query) {
    List<DBModel> searchResults = [];
    if (query.isNotEmpty) {
      transferList.then((list) {
        list.forEach((item) {
          if (item.name!.toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(item);
          }
        });
        setState(() {
          filteredList = searchResults;
        });
      });
    } else {
      transferList.then((list) {
        setState(() {
          filteredList = list;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Money'),centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: searchController,
               
                onChanged: filterSearchResults,cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Search for Users',
                  labelStyle: TextStyle(color: AppColor.backgroundColor),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              filterSearchResults('');
                            });
                          },
                        )
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.backgroundColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DBModel>>(
                future: transferList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data found.');
                  } else {
                    return filteredList.isNotEmpty
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showTransferDialog(context, () {
                                      double amount = double.tryParse(
                                              controlTransfer.text) ??
                                          0.0;

                                      if (amountChecker(
                                          GlobalVariables().currentBalance,
                                          amount)) {
                                        dbHelper!
                                            .updateUser(DBModel(
                                                id: GlobalVariables().id,
                                                name: GlobalVariables().name,
                                                currentBalance:
                                                    GlobalVariables()
                                                            .currentBalance -
                                                        amount,
                                                email: GlobalVariables().email))
                                            .then((value) {
                                          dbHelper!
                                              .updateUser(
                                            DBModel(
                                                id: filteredList[index].id,
                                                name: filteredList[index].name,
                                                currentBalance:
                                                    filteredList[index]
                                                            .currentBalance! +
                                                        amount,
                                                email:
                                                    filteredList[index].email),
                                          )
                                              .then((value) {
                                                     CustomToast.showToast(
                                              message:
                                                  'Rs.${amount} added to the account of ${filteredList[index].name}');
                                         
                                          }).onError((error, stackTrace) {
                                            CustomToast.showToast(
                                                message: error.toString());
                                          });
                                             CustomToast.showToast(
                                                message:
                                                    'Rs.${amount} deducted from the account of ${GlobalVariables().name}');

                                     
                                        }).onError((error, stackTrace) {
                                          print(error.toString());
                                          CustomToast.showToast(
                                              message: error.toString());
                                          print(error.toString());
                                        });
                                      } else {
                                        CustomToast.showToast(
                                            message: 'Invalid');
                                      }
                                      Navigator.pop(context);
                                    }, controlTransfer);
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                        filteredList[index].name.toString()),
                                    subtitle: Text(
                                      (filteredList[index].email.toString()),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                    children: [
                      Lottie.network('https://lottie.host/18f54481-3fce-4fa2-b47d-e3adef3d2a53/uwF8BUGWF1.json',width:199,),
                    ]),);
                  
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool amountChecker(double currentBalance, double transferAmount) {
  if (currentBalance >= transferAmount) {
    return true;
  }
  return false;
}

void _showTransferDialog(
  BuildContext context,
  VoidCallback onPress,
  TextEditingController controllerTransfer,
) {
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      title: Text(
        'Enter Transfer Amount',
        style: TextStyle(fontSize: 16),
      ),
      content: TextField(
        controller: controllerTransfer,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Amount',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 7, 7, 7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 157, 162)),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 0, 157, 162))), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Transfer', style: TextStyle(color: Color.fromARGB(255, 0, 157, 162))),
          onPressed: onPress,
        ),
      ],
    );
  },
);
}