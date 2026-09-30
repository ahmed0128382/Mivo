import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class JoinAgencyRequests extends StatelessWidget {
  const JoinAgencyRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);

    return Scaffold(appBar: AppBar(  iconTheme: IconThemeData(color: Colors.black),centerTitle: true,elevation: 0,title: Text("طلبات الانضمام",style: style6.copyWith(fontSize: 19),)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children:List.generate(Agency.JoinRequestes.length, (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(Agency.JoinRequestes[index].user?.image??''),),
                    SizedBox(width: 5,),
                    UserSideInfoWidgets(UserDate:Agency.JoinRequestes[index].user,TextColor: Colors.black,),
                    Spacer(),
                    Row(
                      children: [
                        InkWell(onTap: () {
                          Agency.AcceptJoinRequests(Agency.JoinRequestes[index].id??0,context);
                        },child: Container(width: 70,height: 40,color: Colors.green,child: Center(child: Text('قبول')),)),
                        SizedBox(width: 15,),
                        InkWell(onTap: () {
                          Agency.refuseJoinRequests(Agency.JoinRequestes[index].id??0,context);
                        },child: Container(width: 70,height: 40,color: Colors.red,child: Center(child: Text('رفض')),))
                      ],
                    )
                  ],
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}
