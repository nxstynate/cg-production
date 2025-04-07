function getOrCreateFolder(folderName) {
  for (var i = 1; i <= app.project.rootFolder.numItems; i++) {
    var item = app.project.rootFolder.item(i);
    if (item instanceof FolderItem && item.name === folderName) {
      return item;
    }
  }
  return app.project.items.addFolder(folderName);
}

function OrganizeProject() {
  app.beginUndoGroup("Organize Project");

  var compFolder = getOrCreateFolder("comp");
  var footageFolder = getOrCreateFolder("footage");

  for (var i = 1; i <= app.project.items.length; i++) {
    var item = app.project.items[i];

    if (item instanceof CompItem) {
      item.parentFolder = compFolder;
    }

    if (item instanceof FootageItem && !(item.mainSource instanceof SolidSource)) {
      item.parentFolder = footageFolder;
    }
  }

  app.endUndoGroup();
}

