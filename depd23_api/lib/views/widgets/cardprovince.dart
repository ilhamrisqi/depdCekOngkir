part of 'widgets.dart';



class CardProvince extends StatefulWidget {

  final Province prov;
  const CardProvince(this.prov);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince> {

  @override
  Widget build(BuildContext context) {
    Province p = widget.prov;
    return Card(
      color: Color(0xFFFFFFFF),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      //untuk membuat list card yang berisi foto berbentuk lingkaran dan judul,sub judul
      child: ListTile(
        //leading
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        //title
        title: Text("${p.province}"),
        //subtitle
        subtitle: Text("${p.province}"),
      ),
    );
    
  }
}