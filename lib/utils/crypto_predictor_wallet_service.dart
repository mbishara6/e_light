
// Make sure you have added web3dart and http to your pubspec.yaml
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class CryptoPredictorWalletService {
  // Set your actual RPC URL and contract address below
  final String rpcUrl = 'https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID'; // <-- Replace with your Infura RPC URL
  final String contractAddress = '0xYourContractAddress'; // <-- Replace with your deployed contract address
  // Paste your contract ABI JSON below
  final String abiString = '''
  [
    // Your ABI JSON goes here
  ]
  ''';

  late Web3Client client;
  late DeployedContract contract;

  CryptoPredictorWalletService() {
    client = Web3Client(rpcUrl, Client());
    contract = DeployedContract(
      ContractAbi.fromJson(abiString, 'CryptoPredictorWallet'),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  Future<List<dynamic>> getWalletBalance() async {
    final balanceFunction = contract.function('getBalance');
    final result = await client.call(
      contract: contract,
      function: balanceFunction,
      params: [],
    );
    return result;
  }

  Future<String> deposit(BigInt amount, Credentials credentials) async {
    final depositFunction = contract.function('deposit');
    final txHash = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: depositFunction,
        parameters: [amount],
      ),
      chainId: null, // Set your chainId if needed
    );
    return txHash;
  }
}
