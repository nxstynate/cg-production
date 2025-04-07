function getSubfolders(folder) {
  return folder.getFiles(function (f) {
    return f instanceof Folder;
  });
}

function cleanCompName(filename) {
  return filename.replace(/\.\w+$/, "").replace(/[_\.-]?\d+$/, "");
}

function compExists(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof CompItem && item.name === name) {
      return true;
    }
  }
  return false;
}

function importSequence(file) {
  var importOptions = new ImportOptions(file);
  importOptions.sequence = true;
  importOptions.forceAlphabetical = true;

  if (importOptions.canImportAs(ImportAsType.FOOTAGE)) {
    importOptions.importAs = ImportAsType.FOOTAGE;
  }

  return app.project.importFile(importOptions);
}

function createCompFromFootage(name, footage) {
  var comp = app.project.items.addComp(
    name,
    footage.width,
    footage.height,
    footage.pixelAspect,
    footage.duration,
    footage.frameRate
  );

  var layer = comp.layers.add(footage);
  layer.transform.scale.setValue([100, 100]);
  return comp;
}

function CreateCompsFromSequences() {
  var scriptRoot = new File($.fileName).parent;
  var aeProjectPath = new File(scriptRoot + "/../../4_images/2_post_production/after_effects/ae-post-production.aep");
  var baseImageSequenceFolder = new Folder(scriptRoot + "/../../4_images/1_raw/1_stills/");

  app.open(aeProjectPath);

  if (!baseImageSequenceFolder.exists) {
    alert("Stills folder not found.");
    return;
  }

  var folders = getSubfolders(baseImageSequenceFolder);

  for (var i = 0; i < folders.length; i++) {
    var folder = folders[i];
    var exrFiles = folder.getFiles("*.exr");

    if (exrFiles.length === 0) {
      $.writeln("Skipping folder: " + folder.name + " (no EXR files)");
      continue;
    }

    var firstFrame = exrFiles[0];
    var compName = cleanCompName(firstFrame.name);

    if (compExists(compName)) {
      $.writeln("Skipping: Comp '" + compName + "' already exists.");
      continue;
    }

    try {
      var footage = importSequence(firstFrame);
      var comp = createCompFromFootage(compName, footage);
      $.writeln("Created comp: " + compName);
    } catch (e) {
      $.writeln("Failed in " + folder.name + ": " + e.message);
    }
  }
}
