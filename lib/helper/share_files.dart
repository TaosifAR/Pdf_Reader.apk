import 'package:share_plus/share_plus.dart';

class Sharepdf{
static Future<void> sharepdf(String path) async{
  if(path.isEmpty)
    return;
  try{
   await Share.shareXFiles([XFile(path)],
   );

  }
  catch(e)
  {

  }
}
}