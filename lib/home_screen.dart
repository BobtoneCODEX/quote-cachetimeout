
import 'package:flutter/material.dart';
import 'quote_model.dart';
import 'quote_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteService quoteService = QuoteService();

  Quote? currentQuote;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  Future<void> loadQuote({bool refresh = false}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final quote = await quoteService.fetchQuote(
        forceRefresh: refresh,
      );

      setState(() {
        currentQuote = quote;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      appBar: AppBar(
        title: const Text('QuickQuotes'),
        backgroundColor: const Color(0xFF101820),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator(),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              if (currentQuote != null && !isLoading)
                Column(
                  children: [
                    Text(
                      '"${currentQuote!.quote}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '- ${currentQuote!.author}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => loadQuote(refresh: true),
                child: const Text('New Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
