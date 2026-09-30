import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
 import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
 import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
 import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../widgets/CircleProgress.dart';
class EditRoom extends StatefulWidget {
  const EditRoom({Key? key}) : super(key: key);
  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {


  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    RoomPlayViewModel  RoomPlay= Provider.of<RoomPlayViewModel>(context, listen: false);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
    return  Container(color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(vertical:50)),
            SliverToBoxAdapter(child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(onTap: (){
                  Room.getImage2();
                },
                  child: Container(  height: 90,width: 100,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(8)  ),child:Room.Roomimage2==null?CachedNetworkImage(imageUrl: Room.Currentroom?.image??'',fit: BoxFit.fill,) :ClipRRect(    borderRadius: BorderRadius.circular((10.0)),child: Image.file(Room.Roomimage2,fit: BoxFit.fill,))),
                ),
                InkWell(onTap: () {
                  Room.clearadd2();
                  Navigator.pop(context);
                },child: const Icon(Icons.clear,size:25,color: MainColor)),

              ],
            ), ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(child:Container(    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(onChanged: (v){
                  setState(() {
                  });
                },controller: Room.EditRoomName, cursorColor: MainColor ,decoration:InputDecoration.collapsed(hintText: getLang(context: context, key: "Name_Room"),hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),

                ) ,),
              ),),),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(child:Container(    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(onChanged: (v){
                  setState(() {
                  });
                },controller: Room.EditRoomDescription, cursorColor: MainColor ,decoration:InputDecoration.collapsed(hintText: getLang(context: context, key: "Room_ADS"),hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),

                ) ,),
              ),),),

            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:4,
                  childAspectRatio:2.7,
                  mainAxisSpacing: 5,
                  crossAxisSpacing:5),
              delegate: SliverChildBuilderDelegate( (context, index) {


                return  InkWell(onTap: ()
                {
                  Room. choosen2.clear();
setState(() {
Room.choosen2.add(user.Roomcatigoris[index]['name']);
});


                },child: Container(
                    decoration: BoxDecoration(
                        color:   !Room.choosen2.contains(user.Roomcatigoris[index]['name'])?Colors.black.withOpacity(0.1):MainColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:   Center(child: Text('# '+user.Roomcatigoris[index]['name'] ,style: TextStyle(fontSize: 12,height: 1,color:!Room.choosen.contains(user.Roomcatigoris[index]['name'])?Colors.black: Colors.white))),
                    )));
              },
                childCount: user.Roomcatigoris.length,
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(child:SingleChildScrollView(  physics: BouncingScrollPhysics(),scrollDirection: Axis.horizontal,child: Row(
              children: [
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(onTap: () {
                    Room.getImage3();
                  },child: Container(child: Center(child: Icon(Icons.image_outlined,color: MainColor,)),height: 140,width: 80,decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),color:  Colors.grey.withOpacity(0.2)))),
                ),
                Row(children:List.generate( user.background.length , (index) => InkWell(onTap: () {
                  Room.backchoosen2.clear();
Room.backchoosen2.add(user.background[index]['image']);
setState(() {

});
                },child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(height: 140,width: 80,decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),border: Border.all(color:Room.backchoosen2.contains(user.background[index]['image'])?MainColor:Colors.transparent,width: 3),image:  DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+user.background[index]['image']),fit: BoxFit.cover)),),
                )
                ))),
              ],
            ))),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(
   child: InkWell(onTap: (){
if(Room.EditRoomName.text.length==0||Room.choosen2.isEmpty||Room.backchoosen2.isEmpty||Room.flagchoosen2.isEmpty||Room.EditRoomDescription.text.length==0)
{


}else{
  Navigator.pop(context);
Room.updateRoom( );
}
//     Room
},child: Center(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: Room.EditRoomName.text.length==0||Room.choosen2.isEmpty||Room.backchoosen2.isEmpty||Room.flagchoosen2.isEmpty?Colors.black45:MainColor),child: Center(child: Text(getLang(context: context,key: "Edit"),style:  style1,)),height:50,width: SizeConfig.screenWidth!,))),

            ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(child:
              InkWell(onTap: (){
if(Room.Currentroom?.chairs?[9].user!=null){
Dialogs().showtoast(getLang(context: context,key: "Shouldbepusy"));

}else{
Dialogs().showdialog(context: context, tittle: getLang( context: context, key: "Close"),content:Room.Currentroom?.SecondKing==0?getLang(context: context,key: "OpenThron"):getLang(context: context,key: "CloseThron"), buttontext: getLang(context: context, key: "Yes"), onTap: (){
Navigator.pop(context);

if(Room.Currentroom?.SecondKing==0){

Room.updateThroneChair(State:'1',context: context );
}else{
Room.updateThroneChair(State:'0',context: context );
}

});
}

//     Room
},child: Container(decoration: BoxDecoration(color:Colors.deepPurpleAccent ,borderRadius: BorderRadius.circular(10) ),child: Center(child: Text(Room.Currentroom?.SecondKing==0?getLang(context: context,key: "Open_Throne_Chair"):getLang(context: context,key: "Close_Throne_Chair"),style:  style1.copyWith(fontSize: 12),)),height:50)),

               ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ),
      ),
    );
  }
}
