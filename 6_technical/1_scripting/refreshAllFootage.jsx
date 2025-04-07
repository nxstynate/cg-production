function RefreshAllFootage() {
  app.beginUndoGroup("Refresh Footage");

  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];

    if (item instanceof FootageItem && item.mainSource instanceof FileSource) {
      var file = item.mainSource.file;

      if (file && file.exists) {
        var importOptions = new ImportOptions(file);
        importOptions.sequence = item.mainSource.isStill === false; // only set true if it was already a sequence
        importOptions.forceAlphabetical = true;

        try {
          item.replaceWithSequence(importOptions); // replaces and preserves sequence
        } catch (e) {
          $.writeln("Failed to refresh: " + item.name + " – " + e.message);
        }
      }
    }
  }

  app.endUndoGroup();
}
