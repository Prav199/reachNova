import 'package:reachnova/models/campaign.dart';
import 'package:reachnova/models/application.dart';
import 'package:reachnova/services/mock_service.dart';

class CampaignRepository {
  final MockService _mockService;

  CampaignRepository({MockService? mockService})
    : _mockService = mockService ?? MockService();

  Future<List<Campaign>> fetchCampaigns() async {
    return await _mockService.getCampaigns();
  }

  Future<Campaign> fetchCampaignDetails(String id) async {
    return await _mockService.getCampaignById(id);
  }

  Future<void> applyForCampaign(Application application) async {
    return await _mockService.submitApplication(application);
  }

  Future<List<Application>> fetchUserApplications(String userId) async {
    return await _mockService.getUserApplications(userId);
  }
}
