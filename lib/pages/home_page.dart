import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/components/expense_tile.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/modules/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //preapare the on startup 
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense
  void addNewExpense() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense name",
              ),
            ),

            //expense amount
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Expense amount",
              ),
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
            ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
            )
        ],
      )
    );
  }

// delete expense
void deleteExpense(ExpenseItem expense) {
  Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
}

//save
void save() {
  if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty) {
    //create expense item
  ExpenseItem newExpense = ExpenseItem(
    name: newExpenseNameController.text, 
    amount: newExpenseAmountController.text, 
    dateTime: DateTime.now(),
    );
    //add the new expense
  Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
  }

  Navigator.pop(context);
  clear();
}

//cancel
void cancel() {
  Navigator.pop(context);
  clear();
}

//clear controllers
void clear() {
  newExpenseNameController.clear();
  newExpenseAmountController.clear();
}

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          //weekly summery
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height: 20),

          //expense list
          ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getAllExpenseList()[index].name, 
            amount: value.getAllExpenseList()[index].amount, 
            dateTime: value.getAllExpenseList()[index].dateTime,
            deleteTapped: (p0) => 
              deleteExpense(value.getAllExpenseList()[index]),
            ),
          ),
        ],)
      ),
    );
  }
}