import 'package:flutter/material.dart';
import 'package:BasicBankingApp/Utils/constants.dart';
import 'package:BasicBankingApp/SQFLite/dbHandler.dart';
import 'package:BasicBankingApp/SQFLite/db_model.dart';
import 'package:BasicBankingApp/Utils/global.dart';
import 'package:BasicBankingApp/Screens/transferMoney.dart';

class Home extends StatefulWidget {
final int? id;
  
  const Home({super.key,  this.id});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DBHelper? dbHelper;
  late Future<List<DBModel>> notesList;

  @override
  void initState() {
    
    super.initState();
    dbHelper = DBHelper();
    loadData();
    DataList();
  }

  loadData() async {
    notesList = dbHelper!.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          
  leading: const BackButton(
    color: Colors.white, // <-- SEE HERE

),

 
        backgroundColor: AppColor.backgroundColor,
        // elevation: 0,
        title: Text(
          'Customers',
          style: TextStyle(color: AppColor.textColorWhite),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          child: DataList(),
        ))
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          dbHelper!
              .insert(DBModel(
                  name: 'Yaseer Abdelhamid',
                  currentBalance: 20000,
                  email: 'yaseerr_2@gmail.com'))
              .then((value) {
            setState(() {
              notesList = dbHelper!.getList();
            });
            

            print('Data Added');
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
      ),
    );
  }
}

class DataList extends StatefulWidget {

  const DataList({super.key});

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  DBHelper? dbHelper;
  late Future<List<DBModel>> notesList;


  @override
  void initState() {
   
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    setState(() {
      notesList = dbHelper!.getList();
    });
  }

  double fontSize = 12;

  int? expandedIndex;

  void toggleDetail(int index) {
    if (expandedIndex == index) {
      setState(() {
        expandedIndex = null;
      });
    } else {
      setState(() {
        expandedIndex = index;
      });
    }
  }

  Future<void> onRefresh() async {
    return loadData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return loadData() != null
        ? RefreshIndicator(
            onRefresh: onRefresh,
            color: AppColor.backgroundColor,
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<DBModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: GestureDetector(
                                onLongPress: () {
                                  deletePopup(context, () {
                                    setState(() {
                                      dbHelper!
                                          .deleteUser(snapshot.data![index].id!)
                                          .then((value) {
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        print(error.toString());
                                      });
                                      notesList = dbHelper!.getList();
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                 
                                  elevation: 8,
                                  shadowColor: Color.fromARGB(255, 181, 248, 245),
                                  color: AppColor.backgroundContainer,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: expandedIndex == index
                                        ? height * 0.66
                                        : height * 0.36,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 22),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColor.backgroundColor,
                                            radius: height * 0.065,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  AppColor.backgroundColor,
                                              backgroundImage: AssetImage(
                                                'assets/man.png',
                                              ),
                                              radius: height * 0.07,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Flexible(
                                            child: Text(
                                              snapshot.data![index].name
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                                color: Color.fromARGB(255, 79, 84, 84),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: width * 0.43,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                toggleDetail(index);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        AppColor
                                                            .backgroundColor),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                   
                                                    Text(
                                                      'User Info',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .textColorWhite),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (expandedIndex == index)
                                            Container(
                                              height: height * 0.27,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), 
                                                      spreadRadius:
                                                          2,
                                                      blurRadius:
                                                          5,
                                                      offset: Offset(0,
                                                          1), 
                                                    ),
                                                  ],
                                                  color: AppColor
                                                      .backgroundContainerSmall,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Name: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: fontSize,
                                                            color:
                                                                Color.fromARGB(255, 115, 115, 115)),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: snapshot
                                                                  .data![index]
                                                                  .name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Email: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                             FontWeight.w600,

                                                            fontSize: fontSize,
                                                            color:
                                                                  Color.fromARGB(255, 115, 115, 115)),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: snapshot
                                                                  .data![index]
                                                                  .email
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            'Current Balance: ',
                                                        style: TextStyle(
                                                                 fontWeight:
                                                             FontWeight.w600,
                                                            
                                                            fontSize: fontSize,
                                                            color:
                                                                 Color.fromARGB(255, 115, 115, 115)),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: snapshot
                                                                  .data![index]
                                                                  .currentBalance
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Center(

                                                      child: SizedBox(
                                                        width: width * 0.50,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            GlobalVariables().email=snapshot.data![index].name!;
                                                           GlobalVariables().id=snapshot.data![index].id!;
                                                               GlobalVariables().name=snapshot.data![index].name!;
                                                           GlobalVariables().currentBalance=snapshot.data![index].currentBalance!;
                                                           print(GlobalVariables().id=snapshot.data![index].id! );


                                                          
                                                            Navigator.push(context, MaterialPageRoute(builder: (_)=>TransferMoney(
                                                           )));
                                          
                                                            dbHelper!
                                                                .updateUser(DBModel(
                                                                    id: snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                    name:
                                                                        "Mohamed Ahmed",
                                                                    currentBalance:
                                                                        2000,
                                                                    email:
                                                                        'Mohamed2@gmail.com'))
                                                                .then((value) {
                                                              setState(() {
                                                                notesList =
                                                                    dbHelper!
                                                                        .getList();
                                                              });
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(error
                                                                  .toString());
                                                            });
                                                             toggleDetail(index);
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(AppColor
                                                                        .backgroundColor),
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .attach_money,
                                                                color: AppColor
                                                                    .iconColorWhite,
                                                              ),
                                                              Text(
                                                                'Transfer Money',
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .textColorWhite),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                        strokeWidth: 3,
                      ),
                    );
                  }
                }))
        : Container();
  }
}

Future<bool> deletePopup(context, VoidCallback onPress) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("delete this user?"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPress,
                        child: Text("Yes"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.iconColorWhite),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text("No", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.iconColorWhite),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
