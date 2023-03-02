import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key, required this.children, required this.distance}) : super(key: key);
  final List<Widget> children;
  final double distance;
  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>  _expandableAnimation;
  bool _open= false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open?1.0:0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this
    );
    _expandableAnimation=CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad
    );
  }
  void _toggle(){
    setState(() {
      _open = !_open;
      if(_open){
        _controller.forward();
      }else{
        _controller.reverse();
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _tapToClose(),
          ..._buildExpandableFabButton(),
          _tapToOpen(),
        ],
      ),
    );
  }
  Widget _tapToClose(){
    return SizedBox(
      height: 55.h,
      width: 55.w,
      child: FloatingActionButton(
        heroTag: 'close',
        backgroundColor: Colors.deepPurple.shade600,
        onPressed: ()=>_toggle,
        child:const Icon(
          Icons.close,
          color: Colors.white,
        ),

      ),

    );
  }
  Widget _tapToOpen(){
   return AnimatedContainer(
       duration: const Duration(milliseconds: 250),
       transformAlignment: Alignment.center,
       transform: Matrix4.diagonal3Values(_open ? 0.7 : 1.0, _open ? 0.7 : 1.0, 1.0),
     curve: Curves.easeOut,
     child: AnimatedOpacity(
       opacity: _open ? 0.0 : 1.0,
       curve: Curves.easeInOut,
       duration: const Duration(milliseconds: 250),
       child: FloatingActionButton(
         heroTag: 'open',
         backgroundColor: Colors.deepPurple.shade600,
         onPressed: _toggle,
         child: const Icon(Icons.add,color: Colors.white,),

       ),
     ),

   );
  }
  List<Widget> _buildExpandableFabButton(){
    final List<Widget> children =<Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count-1);
    for(var i=0, angleDegrees =0.0; i< count; i++, angleDegrees += step ){
      children.add(
        _ExpandableFab(
          directionDegrees: angleDegrees,
          maxDistance: widget.distance,
          progress: _expandableAnimation,
          child: widget.children[i],)
      );
    }
    return children;
  }
}

class _ExpandableFab extends StatelessWidget {

  const _ExpandableFab({Key? key, required this.directionDegrees, required this.maxDistance, this.progress, required this.child}) : super(key: key);
  final double directionDegrees;
  final double maxDistance;
  final Animation<double>? progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress!,
        builder: (context,child){
          final offset =Offset.fromDirection(
            directionDegrees *(math.pi/180),
            progress!.value*maxDistance
          );
          return Positioned(
            right: 4.0 * offset.dx,
            bottom: 4.0 * offset.dy,
            child: Transform.rotate(angle: (1.0 - progress!.value) * math.pi /2,
            child: child,
            ),

          );
        },
        child: FadeTransition(
        opacity: progress!,
        child: child,
    ),
    );
  }
}
