function CreateCompsFromSequences() {
  var aeProjectPath = new File("../../4_images/2_post_production/after_effects/ae-post-production.aep");
  var baseImageSequenceFolder = new Folder("../../4_images/1_raw/1_stills/");

  app.open(aeProjectPath);

  if (!baseImageSequenceFolder.exists) {
    alert("Stills folder not found.");
    return;
  }

  var subfolders = baseImageSequenceFolder.getFiles(function(f) {
    return f instanceof Folder;
  });

  for (var i = 0; i < subfolders.length; i++) {
    var folder = subfolders[i];
    var folderName = folder.name;
    var firstFrame = new File(folder.fsName + "/frame_0001.exr");

    if (!firstFrame.exists) {
      $.writeln("Skipping folder: " + folderName + " (frame_0001.exr not found)");
      continue;
    }

    // Import image sequence
    var importOptions = new ImportOptions();
    importOptions.file = firstFrame;
    importOptions.sequence = true;
    importOptions.forceAlphabetical = true;

    if (importOptions.canImportAs(ImportAsType.FOOTAGE)) {
      importOptions.importAs = ImportAsType.FOOTAGE;
    }

    var footage;
    try {
      footage = app.project.importFile(importOptions);
    } catch (e) {
      $.writeln("Failed to import in " + folderName + ": " + e.message);
      continue;
    }

    // Create comp
    var compName = folderName;
    var compWidth = footage.width;
    var compHeight = footage.height;
    var compPixelAspect = footage.pixelAspect;
    var compDuration = footage.duration;
    var compFrameRate = footage.frameRate;

    var newComp = app.project.items.addComp(compName, compWidth, compHeight, compPixelAspect, compDuration, compFrameRate);
    var layer = newComp.layers.add(footage);
    layer.transform.scale.setValue([100, 100]);

    $.writeln("Created comp: " + compName);
  }

  app.project.save();
}

CreateCompsFromSequences();
