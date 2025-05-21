import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class PaypalScreen extends StatelessWidget {
  final Appointment appointment;
  final String price;

  const PaypalScreen({
    super.key,
    required this.appointment,
    required this.price,
  });

  DateTime parseDate(dynamic value) {
    return value is DateTime ? value : DateTime.parse(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return PaypalCheckoutView(
      sandboxMode: true,
      clientId: dotenv.env['PAYPAL_CLIENT_ID'] ?? "",
      secretKey: dotenv.env['PAYPAL_SECRET'] ?? "",
      // clientId:
      //     "AURtCEWnvA03YzChyXThPXeyY2beJP1RFJlUAzpjk1tBD8Xu166eActAUmwQmf_moWiVAzmxVVCMPdFp",
      // secretKey:
      //     "ECC5-TP5yuNrOYTOXPUvGg6m49UdvPmKOKb3yhG2_r-R-5rdHr7Ryj0NuFWkA6zGKIXWzvk2bmCcpxaw",
      transactions: [
        {
          "amount": {
            "total": price,
            "currency": "USD",
            "details": {
              "subtotal": price,
              "shipping": '0',
              "shipping_discount": 0,
            },
          },
          "description": "Appointment payment",
          "item_list": {
            "items": [
              {
                "name": appointment.appointmentType?.name ?? "Appointment",
                "quantity": 1,
                "price": price,
                "currency": "USD",
              },
            ],
          },
        },
      ],
      note: "Thank you for your payment",
      onSuccess: (Map params) async {
        if (!context.mounted) return;

        final data = params['data'];

        final transaction = {
          "amount": double.parse(data['transactions'][0]['amount']['total']),
          "paymentMethod": data['payer']['payment_method'],
          "paymentId": data['id'],
          "payerId": data['payer']['payer_info']['payer_id'],
          "patientId": appointment.patientId,
          "appointmentId": appointment.appointmentId,
        };

        final updatedAppointment = {
          ...appointment.toJson(),
          "isPaid": true,
          "status": "paid",
          "transactionInsert": transaction,
        };

        final provider = Provider.of<AppointmentsProvider>(
          context,
          listen: false,
        );
        await provider.update(appointment.appointmentId!, updatedAppointment);

        if (context.mounted) {
          Navigator.pop(context, true);
          showSuccessAlert(context, "Payment successful.");
        }
      },
      onError: (error) {
        if (context.mounted) {
          Navigator.pop(context);
          showErrorAlert(context, "Payment error: $error");
        }
      },
      onCancel: () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}
