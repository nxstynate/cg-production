#include "./createCompsFromSequence.jsx"
#include "./refreshAllFootage.jsx"
#include "./saveProject.jsx"
#include "./createLayers.jsx"
#include "./copyTemplateFootageFX.jsx"
#include "./organizeProject.jsx"
#include "./setExtractor.jsx"
#include "./compDurationOfFootage.jsx"
#include "./interpretFootage.jsx.jsx"

function Main() {
  CreateCompsFromSequences()
  CreateLayers()
  copyTemplateFootageFX()
  updateAllExtractors()
  RefreshAllFootage()
  matchCompDurationsToFootage()
  InterpretFootage()
  OrganizeProject()
  SaveProject()
}

Main();
