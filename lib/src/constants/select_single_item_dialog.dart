library select_dialog;

import 'package:flutter/material.dart';
import 'package:select_dialog/select_bloc.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, T item, bool isSelected);

class SelectItemDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final void Function(T) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final Color backgroundColor;
  final TextStyle titleStyle;

  const SelectItemDialog({
    Key key,
    this.itemsList,
    this.showSearchBox,
    this.onChange,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
    this.backgroundColor = Colors.white,
    this.titleStyle,
  }) : super(key: key);

  static Future<T> showModal<T>(BuildContext context,
      {List<T> items,
      String label,
      T selectedValue,
      bool showSearchBox,
      Future<List<T>> Function(String text) onFind,
      SelectOneItemBuilderType<T> itemBuilder,
      void Function(T) onChange,
      InputDecoration searchBoxDecoration,
      Color backgroundColor,
      TextStyle titleStyle}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            label ?? "",
            style: titleStyle,
          ),
          content: SingleChildScrollView(
//            height: 200,
            child: SelectItemDialog<T>(
                selectedValue: selectedValue,
                itemsList: items,
                onChange: onChange,
                onFind: onFind,
                showSearchBox: showSearchBox,
                itemBuilder: itemBuilder,
                searchBoxDecoration: searchBoxDecoration,
                backgroundColor: backgroundColor,
                titleStyle: titleStyle),
          ),
        );
      },
    );
  }

  @override
  _SelectDialogState<T> createState() =>
      _SelectDialogState<T>(itemsList, onChange, onFind);
}

class _SelectDialogState<T> extends State<SelectItemDialog<T>> {
  SelectOneBloc<T> bloc;
  void Function(T) onChange;

  _SelectDialogState(
    List<T> itemsList,
    this.onChange,
    Future<List<T>> Function(String text) onFind,
  ) {
    bloc = SelectOneBloc(itemsList, onFind,null);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showSearchBox ?? true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: bloc.onTextChanged,
              decoration: widget.searchBoxDecoration ??
                  InputDecoration(
                    hintText: "Search",
                    contentPadding: const EdgeInsets.all(2.0),
                  ),
            ),
          ),
        Container(
//          height: 200,
          height: MediaQuery.of(context).copyWith().size.height / 2,
          width: 200,
          child: SingleChildScrollView(
            child: StreamBuilder<List<T>>(
              stream: bloc.filteredListOut,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text("Oops"));
                else if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data.isEmpty)
                  return Center(child: Text("No data found"));
                return ListView.builder(
                  shrinkWrap: true, //MUST TO ADDED
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data[index];
                    if (widget.itemBuilder != null)
                      return InkWell(
                        child: widget.itemBuilder(
                            context, item, item == widget.selectedValue),
                        onTap: () {
                          onChange(item);
                          Navigator.pop(context);
                        },
                      );
                    else
                      return ListTile(
                        title: Text(item.toString()),
                        selected: item == widget.selectedValue,
                        onTap: () {
                          onChange(item);
                          Navigator.pop(context);
                        },
                      );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
