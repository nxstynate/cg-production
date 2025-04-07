function OpenAEFile() {
  var projectFile = new File("../../4_images/2_post_production/after_effects/ae-post-production.aep"); 
  app.open(projectFile);
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

function footageExists(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof FootageItem && item.name === name) {
      return true;
    }
  }
  return false;
}

function getFootageByName(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof FootageItem && item.name === name) {
      return item;
    }
  }
  return null;
}

function getCompByName(name) {
  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];
    if (item instanceof CompItem && item.name === name) {
      return item;
    }
  }
  return null;
}

function CreateComp(name) {
  if (compExists(name)) return;
  app.beginUndoGroup("Create Comp");
  app.project.items.addComp(name, 1920, 1080, 1.0, 10, 24);
  app.endUndoGroup();
}

function cleanName(filename) {
  return filename
    .replace(/\.\w+$/, "") 
    .replace(/[_\.-]?\d+$/, "")
    .replace(/^\s+|\s+$/g, "");
}

function ImportSequence(file, name) {
  if (footageExists(name)) return;
  var importOptions = new ImportOptions(file);
  importOptions.sequence = true;
  importOptions.forceAlphabetical = true;

  if (importOptions.canImportAs(ImportAsType.FOOTAGE)) {
    importOptions.importAs = ImportAsType.FOOTAGE;
  }
  var footage = app.project.importFile(importOptions);
  footage.name = name;
}

function addFootageToComp(name) {
  var comp = getCompByName(name);
  var footage = getFootageByName(name);
  if (!(comp && footage)) return;

  for (var i = 1; i <= comp.numLayers; i++) {
    var layer = comp.layer(i);
    if (layer.source === footage) {
      return; // Already added
    }
  }

  comp.layers.add(footage);
}

function ImportAndCreateCompsFromSequences() {
  var folder = new Folder("../../4_images/1_raw/1_stills/");
  if (!folder.exists) return;

  var files = folder.getFiles("*.exr");
  var seen = {};

  for (var i = 0; i < files.length; i++) {
    var file = files[i];
    if (!(file instanceof File)) continue;

    var name = cleanName(file.name);
    if (seen[name]) continue;

    seen[name] = true;
    ImportSequence(file, name);
    CreateComp(name);
    addFootageToComp(name);
  }
}

function CreateCompsFromSequences() {
  OpenAEFile();
  ImportAndCreateCompsFromSequences();
}
