function getCompByName(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof CompItem && item.name === name) {
      return item;
    }
  }
  return null;
}

function layerExistsInComp(comp, layerName) {
  for (var i = 1; i <= comp.numLayers; i++) {
    if (comp.layer(i).name === layerName) {
      return true;
    }
  }
  return false;
}

function copyLayersToComps() {
  var templateComp = getCompByName("template");
  if (!templateComp) {
    alert("Template comp not found.");
    return;
  }

  var layerNamesToCopy = ["CC", "Film Grain", "Sharpen"];

  app.beginUndoGroup("Copy Template Layers");

  for (var i = 1; i <= app.project.items.length; i++) {
    var comp = app.project.items[i];

    if (!(comp instanceof CompItem)) continue;
    if (comp.name === "template") continue;

    for (var j = 0; j < layerNamesToCopy.length; j++) {
      var layerName = layerNamesToCopy[j];

      // Skip if target comp already has this layer
      if (layerExistsInComp(comp, layerName)) continue;

      var sourceLayer = templateComp.layer(layerName);
      if (sourceLayer) {
        sourceLayer.copyToComp(comp); // direct copy without duplication in template
      }
    }
  }

  app.endUndoGroup();
}

function CreateLayers() {
  copyLayersToComps();
}
