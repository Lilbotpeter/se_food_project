// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';

class UserReport extends StatefulWidget {
  const UserReport({super.key});

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  List<dynamic> dataUser = [];
  bool isLoading = true;

  @override
  void initState() {
    isLoading = false;
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    
    fetchData();
  }

  Future<void> fetchData() async{
    try {
      List<dynamic> reviewList =
                await DetailService().fetchReviewData('Review', '6kWGTLvH3DCd0lT4Rj6c', 'ReviewID');
      
      setState(() {
        dataUser = reviewList;
        isLoading = false;
      });
    } catch (e) {
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Report'),
        ),
        body: ListView.builder(
      itemCount: dataUser.length,
      itemBuilder: (BuildContext context, int index) {

      Map<String, dynamic> data = dataUser[index];
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            
            listTile(data: data, fun: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: 'Report',
                body: Column(
                  children: [
                    
                    Text('Comment : ' + data['Comment']),
                    Text(data['ID_Mod']),
                  ],
                ),
                btnOkOnPress: () {
                  Get.snackbar('title', 'message');
                },
                btnCancelOnPress: () {},
              ).show();
            }),
          ],
        ),
      );
    }


      ));
  }
}

class CardSkale extends StatelessWidget {
  const CardSkale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skale(height: 20,width: 100,),
        Skale(height: 20,width: 30,),
      ],
    );
  }
}

class Skale extends StatelessWidget {
  const Skale({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height,width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

class listTile extends StatelessWidget {
  const listTile({
    Key? key,
    required this.data,
    required this.fun,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final Function fun;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data['Comment']),
      subtitle: Text('Test'),
      trailing: IconButton(icon: Icon(Icons.arrow_right_rounded),
      onPressed: (){
        fun();
      },
      ),
      
    );
  }
}
