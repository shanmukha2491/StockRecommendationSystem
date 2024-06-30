import "package:flutter/material.dart";
import "package:srs/components/search_bar.dart";
import "package:srs/data.dart";

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
            const SizedBox(height: 30,),
            const SearchBarWidget(),
            Expanded(
                child: GridView.builder(
                    itemCount: companyList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return 
                        GestureDetector(
                          onTap: (){
                            final snackBar = SnackBar(
                                  content: Text('You tapped on ${companyList[index]}'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Center(
                            child: Text(companyList[index]),
                          ),
                        )
                      ;
                    }))
          ],
        ));
  }
}
