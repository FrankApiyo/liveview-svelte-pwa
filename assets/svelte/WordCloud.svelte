<script lang="ts">
  import { onMount } from "svelte";
  import vegaEmbed from "vega-embed";

  let chartContainer;

  onMount(() => {
    const spec = {
      $schema: "https://vega.github.io/schema/vega/v5.json",
      description: "A word cloud visualization depicting your journals.",
      width: window.innerWidth * 0.8,
      height: window.innerHeight * 0.4,
      padding: 0,
      data: [
        {
          name: "table",
          values: [
            "Declarative visualization grammars can accelerate development, facilitate retargeting across platforms, and allow language-level optimizations. However, existing declarative visualization languages are primarily concerned with visual encoding, and rely on imperative event handlers for interactive behaviors. In response, we introduce a model of declarative interaction design for data visualizations...",
            "We present Reactive Vega, a system architecture that provides the first robust and comprehensive treatment of declarative visual and interaction design for data visualization...",
            "We present Vega-Lite, a high-level grammar that enables rapid specification of interactive data visualizations...",
          ],
          transform: [
            {
              type: "countpattern",
              field: "data",
              case: "upper",
              pattern: "[\\w']{3,}",
            },
            {
              type: "formula",
              as: "angle",
              expr: "[-45, 0, 45][~~(random() * 3)]",
            },
            {
              type: "formula",
              as: "weight",
              expr: "if(datum.text=='VEGA', 600, 300)",
            },
          ],
        },
      ],
      scales: [
        {
          name: "color",
          type: "ordinal",
          domain: { data: "table", field: "text" },
          range: ["#d5a928", "#652c90", "#939597"],
        },
      ],
      marks: [
        {
          type: "text",
          from: { data: "table" },
          encode: {
            enter: {
              text: { field: "text" },
              align: { value: "center" },
              baseline: { value: "alphabetic" },
              fill: { scale: "color", field: "text" },
            },
            update: {
              fillOpacity: { value: 1 },
            },
            hover: {
              fillOpacity: { value: 0.5 },
            },
          },
          transform: [
            {
              type: "wordcloud",
              size: [800, 400],
              text: { field: "text" },
              rotate: { field: "datum.angle" },
              font: "Helvetica Neue, Arial",
              fontSize: { field: "datum.count" },
              fontWeight: { field: "datum.weight" },
              fontSizeRange: [12, 56],
              padding: 2,
            },
          ],
        },
      ],
    };

    vegaEmbed(chartContainer, spec);
  });
</script>

<div bind:this={chartContainer}></div>
