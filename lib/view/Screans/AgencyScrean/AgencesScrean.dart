import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
class AgencesScrean extends StatefulWidget {

  @override
  State<AgencesScrean> createState() => _AgencesScreanState();
}

class _AgencesScreanState extends State<AgencesScrean> {


  ScrollController? _controller;

  void _scrollListener() {
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  false);
    if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Agency.showloading2){
      Agency.GetMoreAgency(context);
    }
  }

  void initState() {
    _controller = ScrollController();
    _controller?.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);

     return Scaffold(
        body:Agency.showloading?Center(child: CircularProgressIndicator(color: MainColor ),) :
          RefreshIndicator(color: MainColor, onRefresh: ()async{
            Agency.GetAgency(context: context);
     },
          child: SingleChildScrollView(  controller: _controller,
            child: Column(
              children: [
                Container( decoration: BoxDecoration(

                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MainColor,
                        whitecolor,
                      ],
                    )
                ),height: 130, width: SizeConfig.screenWidth,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
  InkWell(onTap: (){
    Navigator.pop(context);
  },child: Icon(Icons.navigate_before_rounded,color: Colors.white,size: 40)),
InkWell(onTap: (){

},child: Text(getLang(context: context, key: "Agencies"),style: style5.copyWith(fontSize: 20))),
  InkWell(onTap: (){
    Navigator.pushNamed(context, AppConstants.SearchAgency_Screan);
  },child: Icon(Icons.search,color: Colors.white,size: 30)),

],
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: List.generate(Agency.Agences.length, (index) =>Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(onTap:(){
                        Agency.GetAgencyinfo(context: context,info: Agency.Agences[index]);
                     Navigator.pushNamed(context, AppConstants.AgencyProfile_Screan);
                      } ,
                        child: Row(
                          children: [
                            Container(height: 85,width: 85,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),image: DecorationImage(image: CachedNetworkImageProvider(
                                Agency.Agences[index].image??Images.relation ),fit: BoxFit.cover), ),
                            ),
                            const        SizedBox(width: 10,),
                            Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Agency.Agences[index].name??'',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 15)),
                                Row(
                                  children: [
                                    Text( 'Id : ${Agency.Agences[index].appid??''} ',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black45)),
                                    const         SizedBox(width: 5,),
                                    InkWell(onTap: (){
                                      Clipboard.setData(ClipboardData(text:Agency.Agences[index].appid??'' ));
                                      Dialogs().showtoast(getLang(context: context, key: "Copied"));
                                    },child:Icon(Icons.copy_outlined,color:Colors.black45,size: 16,)),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: MainColor.withOpacity(0.5),borderRadius:   BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(Agency.Agences[index].user?.name??'',style: style6.copyWith(fontWeight: FontWeight.normal)),
                                      ),
                                    ),
                                    const        SizedBox(width: 10,),
                                    Row(
                                      children: [
                                        Icon(Icons.group,size: 18,color: MainColor) ,
                                        const             SizedBox(width: 5,),
                                        Text( Agency.Agences[index].userNumber.toString() ,style: style6.copyWith(fontSize: 13, color: MainColor,fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    children: [
    if( Agency.Agences[index].agencyKind==1||Agency.Agences[index].agencyKind==2)  Icon(Icons.monetization_on_outlined,size: 20,color:MainColor) ,
      if( Agency.Agences[index].agencyKind==1)  SizedBox(width: 10,),
      if( Agency.Agences[index].agencyKind==0||Agency.Agences[index].agencyKind==2)      Icon(Icons.group,size: 20,color: MainColor) ,
    ],

  ),
)

                          ],
                        ),
                      ),
                    )),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
