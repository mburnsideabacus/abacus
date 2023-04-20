---
layout: default
---

# L4LSessionStatsController

main session stats generator.

**Author** Mike Burnside

**Date** 2022

**Group** Learning For Life

## Methods

### `static getHighAndLowBoundaries()`

`AURAENABLED`

queries lfl_stats_boundary instance of LFL_Stats_Boundary\_\_mdt metadata to obtain the High/Low parameters to control Red/Yellow UI traffic light colours

#### Return

**Type**

LFL_Stats_Boundary\_\_mdt

**Description**

Custom metadata record, lfl_stats_boundary

**Name** getHighAndLowBoundaries

#### Example

```apex
LFL_Stats_Boundary__mdt highsandlows = L4LSessionStatsController.getHighAndLowBoundaries()
```

### `static getD3SessionStatsHistogramData(String clientId)`

`AURAENABLED`

returns the session statistics for a client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client ID |

#### Return

**Type**

List&lt;session_statistics\_\_c&gt;

**Description**

A list of session statistics, List&lt;session_statistics\_\_c&gt;

**Name** getD3SessionStatsHistogramData

#### Example

```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3SessionStatsHistogramData(clientId)
```

### `static getSessionStats(String searchKey)`

`AURAENABLED`

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `searchKey` | The session ID |

#### Return

**Type**

List&lt;Session_Statistics\_\_c&gt;

**Description**

A list of Session_Statistics\_\_c

**Name** getSessionStats

**TODO** fix the parameter naming

#### Example

```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getSessionStats(clientId)
```

### `static getD3Stats(String clientId, Boolean showAcquired)`

`AURAENABLED`

uses SOQL to return a session statistics for a client.

#### Parameters

| Param          | Description                                             |
| -------------- | ------------------------------------------------------- |
| `clientId`     | The client                                              |
| `showAcquired` | A Boolean, should we restrict to previous_status of ACQ |

#### Return

**Type**

List&lt;Session_Statistics\_\_c&gt;

**Description**

a list of session statistics

**Name** getD3Stats

#### Example

```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3Stats(clientId,true|false)
```

### `static getD3StatsByProgram(String clientId, String programStr, Boolean showAcquired)`

`AURAENABLED`

uses SOQL to return a list of session statistics filtered on program name, and optionally previous status

#### Parameters

| Param          | Description                                             |
| -------------- | ------------------------------------------------------- |
| `clientId`     | Client ID                                               |
| `programStr`   | The Program Name                                        |
| `showAcquired` | A Boolean, should we restrict to previous status of ACQ |

#### Return

**Type**

List&lt;Session_Statistics\_\_c&gt;

**Description**

a list of session statistics

**Name** getD3StatsByProgram

#### Example

```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3StatsByProgram(clientId,programStr,true|false)
```

### `static getClientObjectivesByProgram(String clientId)`

`AURAENABLED`

uses SOQL to return a COUNT of objectives from Client_Objectives\_\_c GROUPed BY the program name

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Return

**Type**

List&lt;AggregateResult&gt;

**Description**

A list of aggregate results, List&lt;AggregateResult&gt;

**Name** getClientObjectivesByProgram

#### Example

```apex
List<AggregateResult>  arl = L4LSessionStatsController.getClientObjectivesByProgram(clientId)
```

### `static getD3YAxisScale(String clientId)`

`AURAENABLED`

a helper for D3 charting to establish the scale required for the Y Axis. Uses SOQL to count the # of ACTIVE client_objectives, and # of client_objective_timeseries records for a client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The Client ID |

#### Return

**Type**

Integer

**Description**

an Integer, the higher of the two counts

**Name** getD3YAxisScale

**TODO** look at the requirement for ACTIVE only

#### Example

```apex

```

### `static getD3RetestYAxisScale(String clientId)`

`AURAENABLED`

a helper for D3 charting to establish the scale required for the Retest Y Axis. Uses SOQL to count the # of ACTIVE and Re_Test_Recommended client_objectives and client_objective_timeseries records for a client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The Client ID |

#### Return

**Type**

Integer

**Description**

an Integer, the higher of the two counts

**Name** getD3RetestYAxisScale

**TODO** look at the requirement for ACTIVE only

#### Example

```apex

```

### `static getD3StatusYAxisScale(String clientId)`

`AURAENABLED`

a helper for D3 charting to establish the scale for the Y Axis. Uses SOQL to return the maximum count for any status for all runs of client_objective_timeseries records for a client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client ID |

#### Return

**Type**

Integer

**Description**

an Integer - maximum status count for any run for the client

**Name** getD3StatusYAxisScale

#### Example

```apex

```

### `static getD3StatsByProgramAndSD(String clientId, String programStr, String sdStr, Boolean showAcquired, String periodStr, String stageStr)`

`AURAENABLED`

use SOQL to create a list of session_statistics\_\_c for a client according to filter parameters

#### Parameters

| Param          | Description        |
| -------------- | ------------------ | ---------------------------------- |
| `clientId`     | The client Id      |
| `programStr`   | "All"              | program_name\_\_c                  |
| `sdStr`        | "All" sd_name\_\_c |
| `showAcquired` | True               | False, restrict to ACQ only or not |
| `periodStr`    | "All"              | 30,60,90 days etc                  |
| `stageStr`     | "All"              | objective**r.sd**r.Stage\_\_c      |

#### Return

**Type**

List&lt;Session_Statistics\_\_c&gt;

**Description**

a list of session_Statistics\_\_c

**Name** getD3StatsByProgramAndSD

#### Example

```apex

```

### `static getProgramsAndSds(String stageStr)`

`AURAENABLED`

### `static getClientObjectivesSDCount(String clientId)`

`AURAENABLED`

returns as a List&lt;AggregateResult&gt; the count of client_objectives\_\_c for a client, grouped by program, sd

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client ID |

#### Return

**Type**

List&lt;AggregateResult&gt;

**Description**

An AggregateResult list

**Name** getClientObjectivesSDCount

#### Example

```apex

```

### `static generateD3ProgramAreaSDJson(String clientId, String stageStr)`

`AURAENABLED`

generates a JSON string for use by D3 charting

#### Parameters

| Param      | Description   |
| ---------- | ------------- | -------------- |
| `clientId` | The client Id |
| `stageSt`  | "All"         | sd**c.stage**c |

#### Return

**Type**

String

**Description**

a JSON string

**Name** generateD3ProgramAreaSDJson

**TODO** work on the explanation and provide an example

#### Example

```apex

```

### `static generateD3AreaSDJson(String clientId, String stageStr)`

`AURAENABLED`

generates a JSON string for use by D3 charting

#### Parameters

| Param      | Description   |
| ---------- | ------------- | -------------- |
| `clientId` | The client Id |
| `stageStr` | "All"         | sd**c.stage**c |

#### Return

**Type**

String

**Description**

a JSON string

**Name** generateD3AreaSDJson

**TODO** work on the explanation and provide an example

#### Example

```apex

```

### `static getProgramSetFromCO(String clientId)`

`AURAENABLED`

generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of Programs currently used in this client's client objectives. Used in pull down filters on D3 charts

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Return

**Type**

List&lt;String&gt;

**Description**

A set of Program names as List&lt;String&gt;

**Name** getProgramSetFromCO

**TODO** logging

#### Example

```apex

```

### `static getSDSetFromCO(String clientId)`

`AURAENABLED`

generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of SDs currently used in this client's client objectives. Used in pull down filters on D3 charts

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | the client Id |

#### Return

**Type**

List&lt;String&gt;

**Description**

a set of SD names as List&lt;String&gt;

**Name** getSDSetFromCO

**TODO** logging

#### Example

```apex

```

---