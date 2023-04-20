/**************************************************************
 * @name LFLDTDRates
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 * @see LFLDTDRateMaster
 * @description	the Rate calculations
 *
 */

public with sharing class LFLDTDRates {
  /*******************************************************************************************************
   * @name getAcquisitionRate
   * @description sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a
   * combined JSON string
   *
   *
   * @param clientId the clientId
   * @param retro
   * @return JSON string
   * @TODO is this deprecated?
   * @example
   * String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
   */

  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRate(String clientId, Integer retro) {
    //get date and runid limits

    String jsonStr;
    Integer retro_start_months;

    if (retro == 0)
      retro_start_months = -999;
    else
      retro_start_months = -1 * retro;

    DateTime endpoint = Datetime.now().addMonths(retro_start_months);
    list<aggregateresult> limitDatesList = [
      SELECT
        min(TS_load_DateTime__c),
        max(TS_load_DateTime__c),
        min(runid__c),
        max(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND TS_load_DateTime__c >= :endpoint
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name getAcquisitionRateByDates
   * @description sets up a retrospecitve set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a
   * combined JSON string
   *
   *
   * @param clientId the clientId
   * @param dt1 the starting datetime
   * @param dt2 the ending datetime
   * @return JSON string
   * @example
   * String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
   */

  /* get rates between starting and ending dates*/
  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRateByDates(
    String clientId,
    DateTime dt1,
    DateTime dt2
  ) {
    //get date and runid limits

    String jsonStr;

    System.debug('received dt1=' + dt1 + ' dt2=' + dt2);
    if (dt2 <= dt1) {
      throw new L4LRateCalculationException(
        'end date must be after start date'
      );
    }

    list<aggregateresult> limitDatesList = [
      SELECT
        min(TS_load_DateTime__c),
        max(TS_load_DateTime__c),
        min(runid__c),
        max(runid__c)
      FROM client_objective_timeseries__c
      WHERE
        client__c = :clientId
        AND TS_load_DateTime__c > :dt1
        AND TS_load_DateTime__c <= :dt2
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name buildJson
   * @description helper to do the grunt work of building JSON
   *
   *
   * @param clientId the clientId
   * @param limitDatesList List<AggregateResult>
   * @return JSON string
   * @example
   * String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
   */
  private static String buildJson(
    String clientId,
    list<aggregateresult> limitDatesList
  ) {
    String jsonStr;

    AggregateResult limitDates = limitDatesList[0];
    if (limitDates.get('expr0') == null) {
      jsonStr = '{';
      jsonStr += '"rate":' + 0;
      jsonStr += ',"startd":"2022-10-30"';
      jsonStr += ',"endd":"2022-10-30"';
      jsonStr += ',"elapsed":' + 0;
      jsonStr += ',"startAcquiredCount":' + 0;
      jsonStr += ',"endAcquiredCount":' + 0;
      jsonStr += ',"numberAcquiredInPeriod":' + 0;
      jsonStr += ',"sessionCount":' + 0;
      jsonStr += ',"weeks":' + 0;
      jsonStr += ',"acquiredPerSession":' + 0;
      jsonStr += ',"totalSessionDurationHrs":' + 0;
      jsonStr += '}';
      return jsonStr;
    }

    DateTime startdt = (DateTime) limitDates.get('expr0');
    DateTime enddt = (DateTime) limitDates.get('expr1');
    String startRunId = (String) limitDates.get('expr2');
    String endRunId = (String) limitDates.get('expr3');
    System.debug('startRunId=' + startRunId + ' , endRunId=' + endRunid);

    //coerce DateTimes to Dates for elapsed calcs
    Date startd = startdt.date();
    Date endd = enddt.date();

    // work out the number of acquired skills at the start
    list<aggregateresult> startingACQCountList = [
      SELECT count(id)
      FROM client_objective_timeseries__c
      WHERE
        client__c = :clientId
        AND status__c = 'ACQ'
        AND runId__c = :startRunId
    ];

    Integer startAcquiredCount = (Integer) startingACQCountList[0].get('expr0');

    //work out the number of acquired skills at the end
    list<aggregateresult> endingACQCountList = [
      SELECT count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND status__c = 'ACQ' AND runid__c = :endRunId
    ];

    Integer endAcquiredCount = (Integer) endingACQCountList[0].get('expr0');

    System.debug(
      'startAcquiredCount = ' +
      startAcquiredCount +
      ' endAcquiredCount=' +
      endAcquiredCount
    );

    // work out the elapsed days
    Integer elapsed = startd.daysBetween(endd);

    Decimal weeks = (Decimal) elapsed / 7;

    Integer numberAcquiredInPeriod = endAcquiredCount - startAcquiredCount;

    // calculate the weekly rate of acquisition
    Decimal rate;
    if (elapsed != 0) {
      rate = (decimal) (numberAcquiredInPeriod) / (weeks);
    } else
      rate = 0;

    // work out the number of sessions
    list<aggregateresult> sessionCountList = [
      SELECT count(id), sum(session_length__c)
      FROM session__c
      WHERE client__c = :clientId AND Date__c > :startd AND date__c <= :endd
    ];

    Integer sessionCount = (Integer) sessionCountList[0].get('expr0');

    Decimal totalSessionDurationHrs = (Decimal) sessionCountList[0]
      .get('expr1');

    if (totalSessionDurationHrs == null)
      totalSessionDurationHrs = 1.0;

    Decimal acquiredPerSession;
    if (sessionCount != 0) {
      acquiredPerSession = (Decimal) numberAcquiredInPeriod / sessionCount;
    } else {
      acquiredPerSession = 0;
    }

    //create JSON return
    jsonStr = '{';
    jsonStr += '"rate":' + rate.setScale(2);
    jsonStr +=
      ',"startd":"' +
      startdt.year() +
      '-' +
      startdt.month() +
      '-' +
      startdt.day() +
      '"';
    jsonStr +=
      ',"endd":"' +
      enddt.year() +
      '-' +
      enddt.month() +
      '-' +
      enddt.day() +
      '"';
    jsonStr += ',"elapsed":' + elapsed;
    jsonStr += ',"startAcquiredCount":' + startAcquiredCount;
    jsonStr += ',"endAcquiredCount":' + endAcquiredCount;
    jsonStr += ',"numberAcquiredInPeriod":' + numberAcquiredInPeriod;
    jsonStr += ',"sessionCount":' + sessionCount;
    jsonStr += ',"weeks":' + weeks.setScale(2);
    jsonStr += ',"acquiredPerSession":' + acquiredPerSession.setScale(2);
    jsonStr +=
      ',"totalSessionDurationHrs":' + totalSessionDurationHrs.setScale(2);

    jsonStr += '}';

    return jsonStr;
  }
}