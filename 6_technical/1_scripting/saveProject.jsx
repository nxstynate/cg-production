function SaveProject() {
  if (app.project.file) {
    app.project.save();
    $.writeln("Project saved successfully.");
  } else {
    $.writeln("Project has not been saved yet.");
  }
}

