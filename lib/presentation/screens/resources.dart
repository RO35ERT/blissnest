import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure you import the url_launcher package
import '../../theme/colors.dart'; // Import your color theme

class ResourceTab extends StatelessWidget {
  const ResourceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resources',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: peachColor, // Customize your title color
                ),
              ),
              const SizedBox(height: 20), // Space below the title
              Expanded(
                child: ListView(
                  children: [
                    _buildResourceCard(
                      context,
                      title: 'Mental Health Awareness',
                      description:
                          'Learn about mental health issues and solutions.',
                      videoUrl: 'https://youtu.be/lrhPTqholcc',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Support Groups',
                      description: 'Find support groups in your area.',
                      videoUrl: 'https://youtu.be/7EX1Xnvvk5c',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Coping Strategies',
                      description:
                          'Effective coping strategies for mental well-being.',
                      videoUrl: 'https://youtu.be/gyQX6bU1NIY',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Crisis Management',
                      description: 'How to manage a mental health crisis.',
                      videoUrl: 'https://youtu.be/VRxOmosteCc',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Self-Care Tips',
                      description: 'Tips for self-care and emotional wellness.',
                      videoUrl: 'https://youtu.be/VlDgowUAyx4',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Mindfulness Practices',
                      description: 'Mindfulness techniques for relaxation.',
                      videoUrl: 'https://youtu.be/TWNL7EClClo',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Mental Health Resources',
                      description: 'A list of valuable resources and websites.',
                      videoUrl: 'https://youtu.be/VVFr7onJb9M',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Finding Help',
                      description:
                          'How to find professional help for mental health.',
                      videoUrl: 'https://youtu.be/54fATjln3g0',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Understanding Therapy',
                      description: 'What to expect from therapy.',
                      videoUrl: 'https://youtu.be/RhKBi52H0j8',
                    ),
                    const SizedBox(height: 10),
                    _buildResourceCard(
                      context,
                      title: 'Emergency Contacts',
                      description: 'Know when to seek immediate help.',
                      videoUrl: 'https://youtu.be/oGqu_U0EI8c',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context,
      {required String title,
      required String description,
      required String videoUrl}) {
    return Card(
      color: peachColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // Open the video URL
          _launchInWebView(Uri.parse(videoUrl));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInWebView(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("Failed to launch");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
