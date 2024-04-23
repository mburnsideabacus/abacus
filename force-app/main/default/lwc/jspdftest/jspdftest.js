import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class JsPDFTest extends LightningElement {
  d3Initialized = false; //rendering and control flags

  connectedCallback() {
    console.log("XX in connectedCallback");
  }

  renderedCallback() {
    console.log("XX in renderedCallback");

    // if (this.d3Initialized) {
    //   return;
    // }
    // this.d3Initialized = true;

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(() => {
        console.log("calling initializeD3()");
        this.initializeD3();
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  initializeD3() {
    console.log("XX");
    let doctype =
      '<?xml version="1.0" standalone="no"?>' +
      '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';

    let s = d3.select(this.template.querySelector("svg"));
    console.log("XXXX " + s.node());
    //serialize our SVG XML to a string.
    var source = new XMLSerializer().serializeToString(s.node());

    //console.log("XXXXXXX src=" + source);

    // create a file blob of our SVG.
    // var blob = new Blob([doctype + source], {
    //   type: "image/svg+xml;charset=utf-8"
    // });

    var blob = new Blob([doctype + source], {});

    //var blob = new Blob([doctype + source]);

    console.log("XXXXXXXX blob=" + blob);
    var url = URL.createObjectURL(blob);
    window.open(url, "_blank");
    console.log("XXXXXXXX url===>" + url);

    var img = d3
      .select(this.template.querySelector(".mytest"))
      .append("img")
      .attr("width", 100)
      .attr("height", 100)
      .node();

    img.onload = function () {
      // Now that the image has loaded, put the image into a canvas element.
      var canvas = d3
        .select(this.template.querySelector(".mytest"))
        .append("canvas")
        .node();
      canvas.width = 100;
      canvas.height = 100;
      var ctx = canvas.getContext("2d");
      ctx.drawImage(img, 0, 0);
      var canvasUrl = canvas.toDataURL("image/png");
      var img2 = d3
        .select(this.template.querySelector(".mytest"))
        .append("img")
        .attr("width", 100)
        .attr("height", 100)
        .node();
      // this is now the base64 encoded version of our PNG! you could optionally
      // redirect the user to download the PNG by sending them to the url with
      // `window.location.href= canvasUrl`.
      img2.src = canvasUrl;
      console.log("XXXX canvas url  " + canvasUrl);
    };
    img.src = url;
  }
}
