import { LightningElement, wire, api } from "lwc";
import { logInfo } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

import getAcquisitionRateByDates from "@salesforce/apex/LFLDTDRates.getAcquisitionRateByDates";

const TAG = "L4L-TimeSeries-Summary-Panel";
const SCENARIO = "View the COTS Summary Panel - LWC";
const COMPONENT = "l4lDTDAcquistionRate";

//const TAG = "L4L-Rates";
const sd = new Date("2022-03-25"); //just an arbritary early date, i.e. long before TimeSeries
const ed = new Date();
export default class LflDTDAcquisitionRate extends LightningElement {
  @api recordId;
  rate;
  startd;
  endd;
  numberAcquiredInPeriod;
  sessionCount;
  weeks;
  acquiredPerSession;
  totalduration;
  sd = sd;
  ed = ed;

  @wire(getAcquisitionRateByDates, {
    clientId: "$recordId",
    dt1: sd,
    dt2: ed
  })
  wiredRates({ error, data }) {
    if (data) {
      console.log("DATA ===>" + data);
      let dataObj = JSON.parse(data);
      this.rate = JSON.stringify(dataObj.rate);
      this.startd = dataObj.startd.substring(0, 10);
      this.endd = dataObj.endd.substring(0, 10);
      this.numberAcquiredInPeriod = dataObj.numberAcquiredInPeriod;
      this.sessionCount = dataObj.sessionCount;
      this.weeks = dataObj.weeks;
      this.acquiredPerSession = dataObj.acquiredPerSession;
    } else if (error) {
      console.log("ERROR");
    }
  }

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });

    // setNewSession().then((returnVal) => {
    //   console.log("Success");
    //   logInfo(
    //     this.recordId,
    //     `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
    //     `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
    //     `${TAG}`
    //   );
    // });
  }
}
