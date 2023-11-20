import 'package:flutter/material.dart';
import 'package:REUZEIT/theme/string.dart';
import 'package:REUZEIT/uiwidget/robotoTextWidget.dart';
import '../../../theme/color.dart';
import '../model/categorymodel.dart'as categoryPrefix;

class CategoryListWidget extends StatefulWidget {
  CategoryListWidget({
    Key? key,
    required this.callback,
    required this.selectCategoryList,
  }) : super(key: key);

  List<categoryPrefix.Datum> selectCategoryList;
  final void Function(categoryPrefix.Datum) callback;

  @override
  _SearchNameState createState() => _SearchNameState();
}

class _SearchNameState extends State<CategoryListWidget> {
  // All names
  List<categoryPrefix.Datum> allNames = [];
  List<categoryPrefix.Datum> searchedNames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchedNames = widget.selectCategoryList;
    allNames = widget.selectCategoryList;
  }

  // changes the filtered name based on search text and sets state.
  void _searchChanged(String searchText) {
    if (searchText != null && searchText.isNotEmpty) {
      setState(() {
        searchedNames =
            List.from(allNames.where((name) => name.category.toLowerCase().contains(searchText.toLowerCase())));
      });
    } else {
      setState(() {
        searchedNames = List.from(allNames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: robotoTextWidget(
            textval: search,
            colorval: Colors.white,
            sizeval: 12,
            fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
            // calls the _searchChanged on textChange
            onChanged: (search) => _searchChanged(search),
              decoration: InputDecoration(
                  labelText: search,
                  hintText: search,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))))
          )),
          Expanded(
            child: ListView.builder(
              itemCount: searchedNames.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  widget.callback(searchedNames[index]);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Card(
                      color: AppColor.whiteColor,
                      elevation: 10,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColor.greyBorder,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(padding: EdgeInsets.all(15),
                      child: robotoTextWidget(
                          textval: searchedNames[index].category,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
