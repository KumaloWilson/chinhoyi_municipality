import 'package:municipality/models/resident.dart';

class FinancesHelper{
  static double calculateTotalMonthlyBills({required List<Resident> residents}) {
    double totalBills = 0.0;

    for (Resident resident in residents) {
      if (resident.balances != null && resident.balances!.isNotEmpty) {
        // Get the most recent balance
        final latestBalance = resident.balances!.last;
        totalBills += latestBalance.monthTotal;
      }
    }

    return totalBills;
  }

}