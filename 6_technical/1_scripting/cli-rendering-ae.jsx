// Reload All Footage in Active Composition

var comp = app.project.activeItem;
if (comp) {
  for (var i = 1; i <= comp.numLayers; i++) { // Iterate through all layers
    var layer = comp.layer(i);
    if (layer) {
      var source = layer.property("Source"); // Get the source property
      if (source.value instanceof FootageItem) { // Check if it's footage
        var footageItem = source.value;
        try {  // Add a try-catch block for error handling
          footageItem.reload();
          // Optional: Log or display a message (use with caution, can flood the console)
          // $.writeln("Reloaded footage for layer: " + layer.name);  // Or alert if you prefer
        } catch (e) {
          $.writeln("Error reloading footage for layer: " + layer.name + ": " + e); // Log the error
        }
      }
    }
  }
  $.writeln("Finished processing all layers."); // Confirmation message
} else {
  $.writeln("No active composition found.");
}
