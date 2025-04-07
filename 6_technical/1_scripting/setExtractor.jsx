function getCompByName(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof CompItem && item.name === name) {
      return item;
    }
  }
  return null;
}

function getLayerByName(comp, name) {
  for (var i = 1; i <= comp.numLayers; i++) {
    if (comp.layer(i).name === name) {
      return comp.layer(i);
    }
  }
  return null;
}

function setExtractorCryptomatte(layer) {
  var extractor = layer.effect("Extractor") || layer.effect("ADBE EXtractoR");
  if (!extractor) return;

  try {
    var cryptoLayerProp = extractor.property("Cryptomatte Layer");
    if (cryptoLayerProp) {
      cryptoLayerProp.setValue("ViewLayer.Combined");
    }
  } catch (e) {
    $.writeln("Failed to update Extractor on " + layer.name + ": " + e.message);
  }
}

function updateAllExtractors() {
  app.beginUndoGroup("Set Extractor Cryptomatte Layer");

  for (var i = 1; i <= app.project.items.length; i++) {
    var comp = app.project.items[i];
    if (!(comp instanceof CompItem)) continue;

    var layer = getLayerByName(comp, comp.name); // assumes layer matches comp name
    if (layer) {
      setExtractorCryptomatte(layer);
    }
  }

  app.endUndoGroup();
}

