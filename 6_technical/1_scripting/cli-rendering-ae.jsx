function reloadAndSaveProject() {
  try {
    app.beginUndoGroup("Reload and Save EXRs");

    // Purge memory & disk cache
    app.purge(PurgeTarget.ALL_CACHES);

    if (!app.project || app.project.numItems === 0) {
      $.writeln("No project found.");
      return;
    }

    $.writeln("Reloading all EXR footage in the project...");

    for (var i = 1; i <= app.project.numItems; i++) {
      var item = app.project.item(i);
      if (item instanceof FootageItem && item.file && item.file.name.match(/\.exr$/i)) {
        try {
          item.mainSource.reload();
          $.writeln("Reloaded: " + item.name);
        } catch (e) {
          $.writeln("Error reloading: " + item.name + " – " + e.toString());
        }
      }
    }

    if (app.project.file) {
      app.project.save();
      $.writeln("Project saved successfully.");
    } else {
      $.writeln("Project has not been saved yet.");
    }

    app.endUndoGroup();
  } catch (err) {
    $.writeln("Script error: " + err.toString());
  }
}

reloadAndSaveProject();
