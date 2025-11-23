import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/login2.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key});

  final List<Map<String,dynamic>> gridItems =[
    {
      "image": "assets/images/games.png",
      "buttonText": "العاب",
      "buttonColor": AppColors.green
    },
    {
      "image": "assets/images/video.png",
      "buttonText": "فيديو",
      "buttonColor": AppColors.blue_
    },
    {
      "image": "assets/images/stories.png",
      "buttonText": "قصص",
      "buttonColor": AppColors.purple
    },
    {
      "image": "assets/images/tasks.png",
      "buttonText": "مهام",
      "buttonColor": AppColors.red
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login2(),));
                  },
                      icon: Icon(Icons.arrow_back_ios_new)),
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        Text("نقاطك",style: TextStyle(color: AppColors.blue,fontSize: 25),),
                        Container(
                          width: 100,height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.gray,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColors.red),
                          ),
                          child: Row(
                            children: [
                              Image.asset("assets/images/star.png",height: 50,width: 50,),
                              Text("|",style: TextStyle(color: Colors.black,fontSize: 25)),
                              SizedBox(width: 2,),
                              Text("70",style: TextStyle(color: AppColors.blue,fontWeight: FontWeight.bold,fontSize: 25,fontStyle: FontStyle.italic),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Image.asset("assets/images/image_profile.png",height: 100,width: 100,),
              SizedBox(height: 5,),
              Text("مرحبا غادة",
                style: TextStyle(color: AppColors.blue,fontSize: 20),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: GridView.builder(
                  itemCount: gridItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                gridItems[index]["image"],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gridItems[index]["buttonColor"],
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                gridItems[index]["buttonText"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
