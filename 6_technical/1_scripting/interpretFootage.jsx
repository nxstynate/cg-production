
function InterpretFootage() {
  app.beginUndoGroup("Set Footage to 24fps");

  for (var i = 1; i <= app.project.numItems; i++) {
      var item = app.project.item(i);
      if (item instanceof FootageItem && !item.mainSource.isStill) {
          item.mainSource.conformFrameRate = 24.0;
      }
  }

  app.endUndoGroup();
}

InterpretFootage();
