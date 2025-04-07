function matchCompDurationsToFootage() {
  app.beginUndoGroup("Match Comp Durations to Footage");

  for (var i = 1; i <= app.project.items.length; i++) {
    var comp = app.project.items[i];
    if (!(comp instanceof CompItem)) continue;

    for (var j = 1; j <= comp.numLayers; j++) {
      var layer = comp.layer(j);
      if (layer.source instanceof FootageItem) {
        var footage = layer.source;
        if (footage.mainSource.isStill === false) {
          comp.duration = footage.duration;
          break; // assume first footage layer is the one to match
        }
      }
    }
  }

  app.endUndoGroup();
}
