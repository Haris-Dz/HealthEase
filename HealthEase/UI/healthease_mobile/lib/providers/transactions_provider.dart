import 'package:healthease_mobile/models/transaction.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class TransactionsProvider extends BaseProvider<Transaction> {
  TransactionsProvider() : super("Transaction");

  @override
  Transaction fromJson(data) {
    // TODO: implement fromJson
    return Transaction.fromJson(data);
  }
}
