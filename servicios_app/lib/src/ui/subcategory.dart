import 'package:flutter/material.dart';

import 'category.dart';

class Subcategory extends StatefulWidget {
  Subcategory({Key key, this.category, this.namecategory, this.images, this.categories}) : super(key: key);
  
  final String category;
  final String namecategory;
  final String images;
  final List categories;

  @override
  _SubcategoryState createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  @override
  Widget build(BuildContext context) {

    final image_up = Container(
      //width: 20.0,
      height: 200.0,
      decoration: BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
          image: AssetImage(widget.images),
          fit: BoxFit.fill,
        ),
      ),
    );

    final title = Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width * 1,
      margin: EdgeInsets.only(top:130.0),
      decoration: BoxDecoration(
        color:Colors.black45,
      ),
      child: Column(
        children:<Widget>[
          Container(
            margin: EdgeInsets.only(top:20.0),
            child: Text(
              widget.category,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:25.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]
      )
    );

    List<Widget> allcategories(){
      //print(widget.categories.length);
      //print(widget.categories[0]);
      for(int i=0; i<widget.categories.length; i++){
        Container(
          child: Text(widget.categories[i],style: TextStyle(fontSize:13.0),),
        );
      }
    }

    final contenedor = Container(
      child: ListView.builder(
        itemCount: widget.categories.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i){
          return Container(
            height: 80.0,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Categoryy(category: widget.category, namecategory: widget.categories[i], images: widget.images))),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children:<Widget>[
                    Container(
                      height: 30.0,
                      margin: EdgeInsets.only(
                        top:25.0,
                        right:0.0,
                        left: 0.0,
                      ),
                      child: Text(
                        widget.categories[i],
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,                          
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );

    return Builder(
      builder: (context){
        return Scaffold(
          appBar: AppBar(
            title: Text("Subcategorías", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                child: ListView(
                  children:<Widget>[
                    Stack(
                      children: <Widget>[
                        image_up,
                        title,
                      ],
                    ),
                    contenedor,
                  ]
                ),
              );
            }
          ),
        );
      }
    );
  }
}