import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
class AddPostScrean extends StatefulWidget {
  const AddPostScrean({Key? key}) : super(key: key);

  @override
  State<AddPostScrean> createState() => _AddPostScreanState();
}

class _AddPostScreanState extends State<AddPostScrean> {

  @override
  Widget build(BuildContext context) {
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);
     return  Container(width: SizeConfig.screenWidth,
       decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),

       child: Padding(
         padding: const EdgeInsets.all(15),
         child: Column(mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisSize: MainAxisSize.max,
           children: [

             Row(crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 InkWell(onTap: (){
                   posts.getImage();
                 },
                   child: Container(  height: 90,width: 100,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(8)  ),child:posts.Postimage==null?Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.center,children: [
                       Icon(Icons.image,color: Colors.grey.withOpacity(0.7),size: 40),
                       Text(getLang( context: context, key: "Post_picture"),style: style6.copyWith(fontSize: 10,color: Colors.grey.withOpacity(0.7)),textAlign: TextAlign.center),
                     ],) :ClipRRect(    borderRadius: BorderRadius.circular((10.0)),child: Image.file(posts.Postimage,fit: BoxFit.fill,))),
                 ),
                 Spacer(),
                 InkWell(onTap: () {
                   Navigator.pop(context);
                 },child: Icon(Icons.clear,color: MainColor,))
               ],
             ),
             SizedBox(height: 30,),
             Container(
               decoration: BoxDecoration(color: whitecolor2,borderRadius: BorderRadius.circular(10)),

               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextFormField(onChanged: (v){
setState(() {

});
                 },controller: posts.PostName, cursorColor: MainColor ,textAlign: TextAlign.start,decoration:InputDecoration.collapsed(hintText:'Your Post Tittle',hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),


                 ) ,),
               ),
             ),
           Spacer(),
          InkWell(onTap: (){
               if(posts.PostName.text.length==0|| posts.Postimage==null)
               {
                 print('not');

               }else{

                 posts.AddPost(context: context);

               }
               //     Room
             },child: Center(child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: posts.PostName.text.length==0|| posts.Postimage==null ?Colors.black12:MainColor ),child: Center(child: Text(getLang(key: "Save",context: context),style:  style1,)),height:45,width: SizeConfig.screenWidth!,),
             ))),
             SizedBox(height: 20,),
           ],
         ),
       ),
     );
  }
}
