part of 'widgets.dart';




class UILoading{

static Container loadingBlock(){

return Container(
  alignment: Alignment.center,
  width: double.infinity,
  height: double.infinity,
  color: Colors.black12,
  child: const SpinKitFadingCircle(
    size: 50,
    color: Colors.purple,
  ),
);

}

static Container loading(){
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      color: Colors.transparent,
      child: const SpinKitFadingCircle(
        size: 30,
        color: Color(0xFF00BEFD),
      ),
    );
  }

}