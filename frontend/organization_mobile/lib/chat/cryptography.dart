import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> generateKeyPair() {
  var helper = RsaKeyHelper();
  return helper.computeRSAKeyPair(helper.getSecureRandom());
}


