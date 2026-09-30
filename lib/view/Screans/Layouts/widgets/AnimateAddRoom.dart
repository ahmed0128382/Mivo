import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class AddRoomScrean extends StatefulWidget {
  const AddRoomScrean({Key? key}) : super(key: key);
  @override
  State<AddRoomScrean> createState() => _AddRoomScreanState();
}

class _AddRoomScreanState extends State<AddRoomScrean> {

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
     LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
       return   Container(color: Colors.white,
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10),
           child: CustomScrollView(
             slivers: [
               SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
               SliverToBoxAdapter(child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   InkWell(onTap: (){
                     Room.getImage();
                   },
                     child: Container(  height: 90,width: 100,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(8)  ),child:Room.Roomimage==null?Icon(Icons.image,color: MainColor.withOpacity(0.7),size: 50) :ClipRRect(    borderRadius: BorderRadius.circular((10.0)),child: Image.file(Room.Roomimage,fit: BoxFit.fill,))),
                   ),
                   InkWell(onTap: () {
                     Room.clearadd();
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
            },controller: Room.RoomName, cursorColor: MainColor ,decoration:InputDecoration.collapsed(hintText: getLang(context: context, key: "Name_Room"),hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),

            ) ,),
      ),),),
               SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
               SliverToBoxAdapter(child:Container(    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),

                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: TextFormField(onChanged: (v){
                     setState(() {
                     });
                   },controller: Room.RoomAds, cursorColor: MainColor ,decoration:InputDecoration.collapsed(hintText: getLang(context: context, key: "Room_ADS"),hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),

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
                     Room. choosen.clear();
setState(() {
Room.choosen.add(user.Roomcatigoris[index]['name']);
});

                   },child: Container(
decoration: BoxDecoration(
color:  !Room.choosen.contains(user.Roomcatigoris[index]['name'])?Colors.black.withOpacity(0.1):MainColor.withOpacity(0.7),
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
                     Room.backchoosen.clear();
                   Room.backchoosen.add(user.background[index]['image']);
              setState(() {
             });
     },child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 5),
       child: Container(height: 140,width: 80,decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),border: Border.all(color:Room.backchoosen.contains(user.background[index]['image'])?MainColor:Colors.transparent,width: 3),image:  DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+user.background[index]['image']),fit: BoxFit.cover)),),
     )
    ))),
                 ],
               ))),
               SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
               SliverToBoxAdapter(child: InkWell(onTap: (){
                 bool existed = false;
                 insult.forEach((item) {
                   if(item.contains(Room.RoomName.text)){
                     existed = true;
                     print(item);
                   }   });
                 if(existed==true){

                 }else{

                 }
                 if(  Room.RoomName.text.length==0|| Room.RoomAds.text.length==0||Room.choosen.isEmpty||Room.Roomimage==null||Room.backchoosen.isEmpty)
                 {


                 }else{
                   if(existed==true){
                     Room.Addinsults(context: context,message: Room.RoomName.text,type: 'Create Room' );
                     Dialogs().showdialog4(context: context,  content: getLang(context: context, key: "sults"), );
                   }else{
                     Room.CreateRoom(context: roomcontext, name: Room.RoomName.text, Category: Room.choosen.first, city: Room.flagchoosen , backgroundimage: Room.backchoosen.first);

                     Navigator.pop(context);
                   }

                 }

               },child: Center(child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 0),
                 child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: Room.RoomName.text.length==0||Room.choosen.isEmpty||Room.Roomimage==null||Room.backchoosen.isEmpty?Colors.black12:MainColor ),child: Center(child: Text(getLang(key:"Save",context: context ),style:  style1,)),height:45,width: SizeConfig.screenWidth!,),
               ))),),

               SliverPadding(padding: EdgeInsets.symmetric(vertical: 60)),

             ],


           ),
         ),
       );
  }
}
