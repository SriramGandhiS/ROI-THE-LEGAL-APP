import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:login_signup/theme/app_colors.dart';

class NewsDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;
  final String targetLanguage;

  const NewsDetailScreen({
    super.key,
    required this.article,
    required this.targetLanguage,
  });

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isLoading = true;
  String _summary = '';
  
  static const _kGroqKey = 'YOUR_GROQ_API_KEY_HERE'; // TODO: Move to secure config

  static const _kGroqUrl = 'https://api.groq.com/openai/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _fetchAISummary();
  }

  Future<void> _fetchAISummary() async {
    final title = widget.article['title'] ?? '';
    final description = widget.article['description'] ?? '';
    final content = widget.article['content'] ?? '';
    
    final prompt = """
You are a helpful legal news assistant. 
Summarize the following news article in about 4-5 concise bullet points.
IMPORTANT: The summary MUST be in ${widget.targetLanguage}.
If the article is about Indian law, explain the legal significance briefly.
Title: $title
Description: $description
Content: $content
""";

    try {
      final response = await http.post(
        Uri.parse(_kGroqUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_kGroqKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {'role': 'system', 'content': 'You are a professional legal news summarizer.'},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.5,
          'max_tokens': 512,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _summary = data['choices']?[0]?['message']?['content'] ?? 'Could not generate summary.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _summary = 'Failed to load AI summary. Please read the full article below.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _summary = 'Error generating summary. Network issue.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSourceBadge(),
                  const SizedBox(height: 12),
                  Text(
                    widget.article['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAISummarySection(),
                  const SizedBox(height: 32),
                  _buildFullArticleAction(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: widget.article['urlToImage'] != null
            ? Image.network(
                widget.article['urlToImage'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.primaryBg),
              )
            : Container(color: AppColors.primaryBg),
      ),
    );
  }

  Widget _buildSourceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.article['source']?['name'] ?? 'Legal Update',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildAISummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI SUMMARY (${widget.targetLanguage.toUpperCase()})',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isLoading
              ? _buildLoadingState()
              : Text(
                  _summary,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.6,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const LinearProgressIndicator(
          backgroundColor: AppColors.primaryBg,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 12),
        Text(
          'Summarizing and translating with AI...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontFamily: 'Inter',
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFullArticleAction() {
    return Center(
      child: Column(
        children: [
          Text(
            'Want to read the full context?',
            style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _launchURL(widget.article['url']),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text(
              'View Original Article',
              style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'PlusJakartaSans'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
