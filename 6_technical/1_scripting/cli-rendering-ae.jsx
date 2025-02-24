// Purge all memory & disk caches before reloading footage
app.purge(PurgeTarget.ALL_CACHES);

var comp = app.project.activeItem;
if (comp) {
  for (var i = 1; i <= comp.numLayers; i++) {
    // Iterate through all layers
    var layer = comp.layer(i);
    if (layer) {
      var source = layer.property("Source"); // Get the source property
      if (source.value instanceof FootageItem) {
        // Check if it's footage
        var footageItem = source.value;
        try {
          // Try to reload the footage
          footageItem.reload();
          // Optional: $.writeln("Reloaded footage for layer: " + layer.name);
        } catch (e) {
          $.writeln(
            "Error reloading footage for layer: " + layer.name + ": " + e,
          );
        }
      }
    }
  }
  $.writeln("Finished processing all layers.");
} else {
  $.writeln("No active composition found.");
}
