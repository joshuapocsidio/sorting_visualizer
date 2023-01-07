import 'package:flutter/material.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/widgets/InputField.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/widgets/SorterCustomButton.dart';

class ParameterPanel extends StatefulWidget {
  final Function(int) updateArraySize;
  final int initialArraySize;

  ParameterPanel({required this.initialArraySize, required this.updateArraySize});
  @override
  _ParameterPanelState createState() => _ParameterPanelState();
}

class _ParameterPanelState extends State<ParameterPanel> {
  bool isModifiable = false;
  bool submitEnable = true;
  bool showOriginal = true;
  bool showOutPlaceArray = true;

  late String _speedMode;
  late int _arraySize;
  final TextEditingController _arraySizeController = TextEditingController();
  final Map<String, SortSpeed> _speedMap = {
    'Very Slow': SortSpeed.VerySlow,
    'Slow': SortSpeed.Slow,
    'Normal' : SortSpeed.Normal,
    'Fast' : SortSpeed.Fast,
    'Very Fast' : SortSpeed.VeryFast,
    'Instant' : SortSpeed.Instant,
  };

  Column _getLegend() {
    List<ListTile> legend = [];
    SortChoice sortChoice = SortController.instance.sortChoice;
    setState(() {
      switch(sortChoice) {
        case SortChoice.Insertion:
          legend.addAll([
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.blue,
              ),
              title: Text("Comparison A Index"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.red,
              ),
              title: Text("Comparison B Index"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.purple,
              ),
              title: Text("Iteration Index"),
            ),
          ]);
          break;
        case SortChoice.Selection:
          legend.addAll([
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.red,
              ),
              title: Text("Comparison Index"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.purple,
              ),
              title: Text("Iteration Index"),
            ),
          ]);
          break;
        case SortChoice.Bubble:
          legend.addAll([
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.blue,
              ),
              title: Text("Comparison A Index"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.red,
              ),
              title: Text("Comparison B Index"),
            ),
          ]);
          break;
        case SortChoice.Merge:
          legend.addAll([
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.blue,
              ),
              title: Text("Merging Dataset"),
            ),
          ]);
          break;
        case SortChoice.Quick:
          legend.addAll([
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.purple,
              ),
              title: Text("Pivot"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.blue,
              ),
              title: Text("Comparison Left Index"),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Colors.red,
              ),
              title: Text("Comparison Right Index"),
            ),
          ]);
          break;
          break;
        case SortChoice.All:
          // TODO: Handle this case.
          break;
      }

    });
    legend.add(
      ListTile(
        leading: Icon(
          Icons.circle_outlined,
          color: Colors.blueGrey,
        ),
        title: Text("Unsorted Values"),
      ),
    );
    legend.add(
      ListTile(
        leading: Icon(
          Icons.circle,
          color: Colors.green.withOpacity(0.7),
        ),
        title: Text("Sorted Values"),
      ),
    );
    return Column(
      children: legend,
    );
  }

  void _setSpeed(String speedString) {
    setState(() {
      _speedMode = speedString;
      SortController.instance.changeSpeed(_speedMap[speedString]!);
    });
  }

  void _updatePanel(bool areInputsValid) {
    setState(() {
      if(areInputsValid) {
        submitEnable = true;
      }
      else {
        submitEnable = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _arraySize = widget.initialArraySize;
    _arraySizeController.text = _arraySize.toString();
    _speedMode = "Normal";
    SortController.instance.changeSpeed(SortSpeed.Normal);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  child: Icon(
                    Icons.vpn_key_outlined,
                    size: 100,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Legend",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
              color: Colors.grey,
            ),
            _getLegend(),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
              color: Colors.grey,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  child: Icon(
                    Icons.settings,
                    size: 100,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Parameters",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
              color: Colors.grey,
            ),
            InputField(
              hint: '0 <= size <= 10,000',
              updateCallback: _updatePanel,
              isNumeric: true,
              defaultInput: _arraySize.toString(),
              label: "Array Size",
              enabled: isModifiable,
              textEditingController: _arraySizeController,
            ),
            SizedBox(height: 5),
            isModifiable ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SorterCustomButton(
                  enable: submitEnable,
                  callback: () {
                    setState(() {
                      if(isModifiable) {
                        // If non numeric, ignore it
                        if(int.tryParse(_arraySizeController.text) == null) {
                          return;
                        }
                        _arraySize = int.parse(_arraySizeController.text);
                        isModifiable = false;
                        widget.updateArraySize(_arraySize);
                      }
                      else{
                      }
                    });
                  },
                  buttonColor: Colors.blue,
                  label: 'Submit',
                ),
                SorterCustomButton(
                  label: 'Cancel',
                  buttonColor: Colors.red,
                  callback: () {
                    setState(() {
                      _arraySizeController.text = _arraySize.toString();
                      isModifiable = false;
                    });
                  },
                  enable: true,
                ),
              ],
            ) : SorterCustomButton(
              buttonColor: Colors.blue,
              callback: () {
                setState(() {
                  isModifiable = true;
                });
              },
              enable: !SortController.instance.isSorting,
              label: 'Modify'
            ),
            SizedBox(height: 10),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: Text(
                    "Speed (ms)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _speedMode,
                    onChanged: (String? speedString) {
                      _setSpeed(speedString!);
                    },
                    items: _speedMap.keys.toList().map<DropdownMenuItem<String>> ((String value) {
                      return DropdownMenuItem<String> (
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
