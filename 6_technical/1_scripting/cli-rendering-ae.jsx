// Purge all memory & disk caches before reloading footage
app.purge(PurgeTarget.ALL_CACHES);

if (app.project && app.project.numItems > 0) {
  for (var i = 1; i <= app.project.numItems; i++) {
    var item = app.project.item(i);
    if (item instanceof CompItem) {
      $.writeln("Processing composition: " + item.name);
      for (var j = 1; j <= item.numLayers; j++) {
        var layer = item.layer(j);
        if (layer.source && layer.source instanceof FootageItem) {
          try {
            layer.source.reload();
            $.writeln("Reloaded footage for layer: " + layer.name);
          } catch (e) {
            $.writeln("Error reloading footage for layer: " + layer.name + ": " + e);
          }
        }
      }
    }
  }
  // Save and reload the project to force After Effects to update links
  var projectPath = app.project.file;
  if (projectPath) {
    app.project.save();
    $.writeln("Project saved.");
  } else {
    $.writeln("Project file is not saved yet.");
  }
} else {
  $.writeln("No project found.");
}
