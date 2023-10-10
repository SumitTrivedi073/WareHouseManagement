import 'package:flutter/material.dart';
import 'package:warehouse_management_app/theme/string.dart';
import 'package:warehouse_management_app/uiwidget/robotoTextWidget.dart';

import '../../theme/color.dart';
import '../model/subCategoryModel.dart'as subCategoryPrefix;

class SubCategoryListWidget extends StatefulWidget {
  SubCategoryListWidget({
    Key? key,
    required this.callback,
    required this.selectSubCategoryList,
  }) : super(key: key);

  List<subCategoryPrefix.Datum> selectSubCategoryList;
  final void Function(subCategoryPrefix.Datum) callback;

  @override
  _SearchNameState createState() => _SearchNameState();
}

class _SearchNameState extends State<SubCategoryListWidget> {
  // All names
  List<subCategoryPrefix.Datum> allNames = [];
  List<subCategoryPrefix.Datum> searchedNames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchedNames = widget.selectSubCategoryList;
    allNames = widget.selectSubCategoryList;
  }

  // changes the filtered name based on search text and sets state.
  void _searchChanged(String searchText) {
    if (searchText != null && searchText.isNotEmpty) {
      setState(() {
        searchedNames =
            List.from(allNames.where((name) => name.subCategory.toLowerCase().contains(searchText.toLowerCase())));
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
                          textval: searchedNames[index].subCategory,
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
