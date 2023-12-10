part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final Costs cost;
  const CardCost(this.cost);

  @override
  State<CardCost> createState() => _cardListCostState();
}

class _cardListCostState extends State<CardCost> {
  @override
  Widget build(BuildContext context) {
    Costs cost = widget.cost;
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/logokurir.png'),
      ),
      title: Text("${cost.description} (${cost.service})}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(var i in cost.cost ?? [])
            Text("Biaya: Rp.${i.value},00" ),
          

           for(var i in cost.cost ??[])
            Text("Estimasi Sampai: Rp.${i.etd} Hari" ),
          

        ],
      ),
    ));
  }
}
