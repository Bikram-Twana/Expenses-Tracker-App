import 'package:expenses_manager_app/expenses.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Expenses blank = Expenses(0, " ", 0, DateTime.now());
          addUpdateExpenses(context, true, blank);
          // setState(() {
          //   expenses.add(Expenses(getID(), "hi", 10, DateTime.now()));
          // });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Expenses Tracker \n Total: ${getTotalExpenses()}"),
        actions: [],
      ),
      body: expenses.isEmpty
          ? Center(
              child: Container(
                height: 200,
                color: Colors.lightBlue,
                child: Text(
                  "No expenses found click + to add",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      (index + 1).toString(),
                      //expenses[index].id.toString(),
                      style: TextStyle(color: Colors.yellow, fontSize: 22),
                    ),
                  ),
                  //leading: Icon(Icons.adjust_sharp),
                  title: Text(expenses[index].category),
                  subtitle: Text("Rs ${expenses[index].amount}"),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    //edit Button
                    IconButton(
                      onPressed: () {
                        Expenses ex = Expenses(
                            expenses[index].id,
                            expenses[index].category,
                            expenses[index].amount,
                            DateTime.now());
                        setState(() {
                          addUpdateExpenses(context, false, ex);
                        });
                      },
                      icon: Icon(Icons.edit),
                    ),

                    //delete Button
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deleteExpenses(expenses[index].id);
                        });
                      },
                    ),
                  ]),
                );
              }),
    );
  }

  Future<dynamic> addUpdateExpenses(
      BuildContext context, bool isAdded, Expenses ex) {
    if (!isAdded) {
      categoryController.text = ex.category;
      amountController.text = ex.amount.toString();
    }
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: isAdded ? Text("Add New Expenses") : Text("Edit Expense"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Enter Category"),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: InputDecoration(labelText: "Enter Amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.of(ctx).pop();
              });
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (isAdded) {
                if (amountController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  return;
                } else {
                  setState(() {
                    expenses.add(Expenses(getID(), categoryController.text,
                        double.parse(amountController.text), DateTime.now()));
                  });
                }
              } else {
                setState(() {
                  Expenses updatedEx = Expenses(ex.id, categoryController.text,
                      double.parse(amountController.text), DateTime.now());
                  editExpenses(ex.id, updatedEx);
                });
              }

              amountController.clear();
              categoryController.clear();
              Navigator.of(ctx).pop();
            },
            child: isAdded ? Text("Add") : Text('Update'),
          ),
        ],
      ),
    );
  }
}
