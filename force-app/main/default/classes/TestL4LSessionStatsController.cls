@isTest
private class TestL4LSessionStatsController {
  @isTest
  static void testGetsessionObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getSessionStats(
      sessionId
    );
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
  }
  @isTest
  static void testGetD3Stats() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3Stats(
      clientId,
      true
    );
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3Stats(clientId, false);
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testGetD3StatsByProgram() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      true
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      false
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testGetD3StatsByProgramAndSD() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      true
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3StatsByProgramAndSD(
      clientId,
      'Color',
      'Identical',
      false,
      '180'
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testgetProgramsAndSds() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Program__c> p = L4LSessionStatsController.getProgramsAndSds();
    System.assert(
      p.size() != 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testgetClientObjectivesSDCount() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<AggregateResult> agg = L4LSessionStatsController.getClientObjectivesSDCount(
      clientId
    );
    System.assert(
      agg.size() > 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }
}