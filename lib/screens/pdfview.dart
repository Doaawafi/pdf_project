import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_project/widgets/action_button.dart';
import 'package:pdf_project/widgets/expandable_fab.dart';
import 'package:share_plus/share_plus.dart';


class PdfViewer extends StatefulWidget {
  static const String id ='/pdf_view';
  final String path;

  const PdfViewer({Key? key, required this.path}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
   bool pdfReady=false;
   int _totalPage =0;
   int _currentPage=0;
   PDFViewController? _pdfViewController;
    bool isNightMode = false ;

  @override
  Widget build(BuildContext context)  {
    return  Scaffold(
      body: Stack(
        children:<Widget> [
         PDFView(
           // defaultPage: _currentPage,
           filePath: widget.path,
           autoSpacing: true,
           enableSwipe: true,
           pageSnap: true,
           swipeHorizontal: false,
           onError: (e){print(e);},
           onRender:(_pages){
            setState(() {
              _totalPage=_pages!;
              pdfReady=true;
            });

           } ,
           onViewCreated: (PDFViewController vc){
             _pdfViewController =vc;
           },
           onPageChanged:(int? page , int? total){
             setState(() {


             });
           },
           onPageError: (page , e){},
           nightMode: isNightMode,
         ),
          !pdfReady? const Center(child: CircularProgressIndicator()) : const Offstage()
        ],
      ),
      floatingActionButton:ExpandableFab(
        distance:35 ,
        children:  [
          ActionButton(
            icon:const Icon(Icons.share_rounded , color: Colors.black,),
            onPressed: (){
              Share.share('  https://play.google.com/store/apps/details?id=com.example.pdf_project  ',);
            },
          ),
          ActionButton(
            icon:const Icon(Icons.save , color: Colors.black,),
            onPressed: (){ },
          ),
          ActionButton(
            icon:const Icon(Icons.nightlight , color: Colors.black,),
            onPressed: (){
              setState(() {
                isNightMode=!isNightMode;

              });
            },
          ),
          ActionButton(
            icon:const Icon(Icons.window , color: Colors.black,),
            onPressed: (){},
          ),
        ],
      ),

    );
  }
}
