<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.2/leaflet.js" integrity="sha512-KMraOVM0qMVE0U1OULTpYO4gg5MZgazwPAPyMQWfOkEshpwlLQFCHZ/0lBXyviDNVL+pBGwmeXQnuvGK8Fscvg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.2/leaflet.css" integrity="sha512-UkezATkM8unVC0R/Z9Kmq4gorjNoFwLMAWR/1yZpINW08I79jEKx/c8NlLSvvimcu7SL8pgeOnynxfRpe+5QpA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
  .leaflet-container {
      font-family: "Avenir", "Helvetica Neue", Arial, Helvetica, sans-serif;
      font-size: 12px;
      font-size: 0.75rem;
      line-height: 1.5;
    }

  .leaflet-tooltip-left:before {
    right: 0;
    margin-right: -12px;
    border-left: 0px;
    border-left-color: rgba(0, 0, 0, 0);
}
.leaflet-tooltip-right:before {
    left: 0;
    margin-left: -12px;
    border-right: 0px;
    border-right-color: rgba(0, 0, 0, 0);
    }
.leaflet-tooltip-own {
    position: absolute;
    padding: 4px;
    background-color: rgba(0, 0, 0, 0);
    border: 0px solid #000;
    color: #000;
    white-space: nowrap;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    pointer-events: none;
    box-shadow: 0 1px 3px rgba(0,0,0,0.4);
}
</style>  