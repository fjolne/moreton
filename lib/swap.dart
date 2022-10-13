import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global.dart';

class SwapScreen extends StatelessWidget {
  final Token? sourceToken;

  const SwapScreen({super.key, this.sourceToken});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: LimitedBox(
        child: Column(children: [
          Stack(alignment: const Alignment(0.95, 0), children: [
            Center(child: Text("Swap", style: tt.titleMedium)),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Done",
                    style: tt.titleMedium?.copyWith(color: cs.primary))),
          ]),
          Expanded(
            child: Container(
              color: cs.surface,
              padding: const EdgeInsets.all(16),
              child: SwapForm(initialSourceToken: sourceToken),
            ),
          )
        ]),
      ),
    );
  }
}

const defaultSourceToken = Token.toncoin;
const defaultDestToken = Token.toncoinERC20;

class SwapForm extends StatefulWidget {
  final Token? initialSourceToken;

  const SwapForm({super.key, this.initialSourceToken});

  @override
  _SwapFormState createState() => _SwapFormState();
}

class _SwapFormState extends State<SwapForm> {
  Token sourceToken = defaultSourceToken;
  Token destToken = defaultDestToken;

  @override
  void initState() {
    super.initState();
    sourceToken = widget.initialSourceToken ?? sourceToken;
    destToken = sourceToken == destToken ? defaultSourceToken : destToken;
  }

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    card(Token token) {
      var tokenAmount = getTokenAmount(token);
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Row(children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("You Pay",
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                TextField(
                  decoration: const InputDecoration(
                      hintText: "0", border: InputBorder.none),
                  style: tt.titleLarge,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("Balance: $tokenAmount",
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ])),
          GestureDetector(
            child: SizedBox(
              width: 128,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image(
                          image: AssetImage(token.blockchain.imageUrl),
                          width: 40,
                          height: 40)),
                  const SizedBox(width: 16),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(token.symbol, style: tt.titleMedium),
                        Text(token.blockchain.type,
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ]),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: cs.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ]),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(children: [
              card(sourceToken),
              const Divider(height: 1),
              card(destToken),
            ])),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: ElevatedButton(
            onPressed: onSwap,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Swap", style: tt.titleMedium),
          ),
        )
      ],
    );
  }

  void onSwap() {}
}
