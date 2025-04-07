
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

function copyEffects(sourceLayer, targetLayer) {
  if (!sourceLayer || !targetLayer || !sourceLayer.effect) return;

  var effects = sourceLayer.effect;

  for (var i = 1; i <= effects.numProperties; i++) {
    var effect = effects.property(i);
    if (!targetLayer.effect.property(effect.name)) {
      targetLayer.effect.addProperty(effect.matchName);

      // Optionally: Copy property values
      for (var j = 1; j <= effect.numProperties; j++) {
        try {
          var sourceProp = effect.property(j);
          var targetProp = targetLayer.effect.property(effect.name).property(j);
          if (sourceProp && targetProp) {
            targetProp.setValue(sourceProp.value);
          }
        } catch (e) {
          $.writeln("Could not copy property: " + effect.name + " - " + e.message);
        }
      }
    }
  }
}

function copyTemplateFootageFX() {
  var templateComp = getCompByName("template");
  if (!templateComp) {
    alert("Template comp not found.");
    return;
  }

  var sourceLayer = getLayerByName(templateComp, "template.exr");
  if (!sourceLayer) {
    alert("Layer 'template.exr' not found in template comp.");
    return;
  }

  app.beginUndoGroup("Apply Template Effects");

  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (!(item instanceof CompItem)) continue;
    if (item.name === "template") continue;

    var targetLayer = getLayerByName(item, item.name); // assume layer name matches comp name
    if (targetLayer) {
      copyEffects(sourceLayer, targetLayer);
    }
  }

  app.endUndoGroup();
}

