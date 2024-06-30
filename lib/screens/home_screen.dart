import "package:flutter/material.dart";
import "package:srs/components/search_bar.dart";
import "package:srs/data.dart";
import "package:srs/screens/stock_screen.dart";

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final companyList = CompanyData().companies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stock Recommendation System"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const SearchBarWidget(),
            const SizedBox(height: 15,),
            Expanded(
                child: GridView.builder(
                    itemCount: companyList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final snackBar = SnackBar(
                            content:
                                Text('You tapped on ${companyList[index]}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockScreen(
                                      stockName: companyList[index],
                                     
                                      )));
                        },
                        child: Card(
                          margin: EdgeInsets.all(6),
                          color: Colors.grey,
                          child: Center(
                            child: Text(companyList[index],style:const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }
}
