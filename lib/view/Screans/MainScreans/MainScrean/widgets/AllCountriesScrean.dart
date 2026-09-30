import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/CountriesRoom.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AllCountriesScrean extends StatelessWidget {
  const AllCountriesScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: const Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context,key: "Countries"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
body: CustomScrollView(
  slivers: [
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      delegate: SliverChildBuilderDelegate( (context, index) {

        return  InkWell(onTap: () {
          Rooms.GetSelectedCountry(Rooms.Countries[index]);
          //  Navigator.pushNamed( context, AppConstants.CountriesRoomScrean);

          navigateTo(context: context,screen:  CountriesRoomScrean());

        },
          child: Container( decoration: BoxDecoration(color: Color(0xFF1878f3).withOpacity(0.05),borderRadius: BorderRadius.circular(5) )
            ,child:Row(
              children: [
                SizedBox(width: 10,),
                Image.asset(
                  Rooms.Countries[index].flag??"", package: countryCodePackageName, width: 17,
                ),
                SizedBox(width: 5,),
                Flexible(child: Text(  Rooms.Countries[index].name??"",maxLines: 1,style: style2.copyWith(height: 1,fontSize: 12,color: Colors.black87.withOpacity(0.6)),))
              ],
            ) ,),
        );
      },
        childCount: Rooms.Countries.length,
      ),
    ),
  ],
),
    );
  }
}
