import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class SearchFamilyScrean extends StatefulWidget {
  @override
  State<SearchFamilyScrean> createState() => _SearchFamilyScreanState();
}

class _SearchFamilyScreanState extends State<SearchFamilyScrean> {
  TabController? Tabcontroller;
  TextEditingController FamilySearchController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);

    return Scaffold(
        appBar: AppBar(  leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), title:   Text('Search Family',style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
        body:DefaultTabController(length: 1, child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(indicator: MaterialIndicator(
              height: 3,
              topLeftRadius: 0,
              topRightRadius: 0, color: Colors.purple,
              bottomLeftRadius: 5,horizontalPadding: 25,
              bottomRightRadius: 5,
              tabPosition: TabPosition.bottom,
            ),
                isScrollable: true,controller: Tabcontroller,
                labelStyle: style2.copyWith(fontSize: 13),
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.black,indicatorPadding:EdgeInsets.symmetric(horizontal: 20) ,
                onTap: (val){
                },
                tabs: const [
                  Tab(
                    text: "Search Family",
                  ),

                ]
            ),
            Expanded(
              child:   Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBarView(
                  children: [
                    TextFormField(controller: FamilySearchController,
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: (){
                        if(FamilySearchController.text!=''){
                          Family. SearchGetFamily(context: context,text: FamilySearchController.text);
                        }
                        print('asdas');
                      },
                      decoration:   InputDecoration(suffixIcon:FamilySearchController.text==''?SizedBox():  InkWell(onTap: () {
                        FamilySearchController.clear();
                        setState(() {

                        });
                      },child: Icon(Icons.clear,color: Colors.black45,size: 22)),  prefixIcon:  Icon(Icons.search_outlined,color: Colors.black45,size: 22),
                        hintText: "Family ID or Name",hintStyle: TextStyle(fontSize: 16 ,color: Colors.black45) ,border: InputBorder.none,
                      ),
                    ),


                  ],
                ),
              ),
            )
          ],
        ),)

    );
  }
}
